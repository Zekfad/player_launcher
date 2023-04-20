import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

final _executablePath = File(Platform.resolvedExecutable);
final _libraryPath = path.join(path.dirname(_executablePath.parent.path), 'Frameworks/libalert.dylib');

final DynamicLibrary _libAlert = DynamicLibrary.open(_libraryPath);

typedef _AlertNative = Bool Function(Pointer<Utf8> header, Pointer<Utf8> message, Uint32 level);
typedef _Alert = bool Function(Pointer<Utf8> header, Pointer<Utf8> message, int level);

final _Alert _alert = _libAlert
    .lookup<NativeFunction<_AlertNative>>('alert')
    .asFunction();

enum AlertLevel {
  plain(0),
  note(1),
  caution(2),
  stop(3),
  ;

  const AlertLevel(this.value);
  final int value;
}

bool alert(String header, String message, [AlertLevel level = AlertLevel.note]) {
  const _allocator = malloc;
  final _header = header.toNativeUtf8(allocator: _allocator);
  final _message = message.toNativeUtf8(allocator: _allocator);
  try {
    return _alert(_header, _message, level.value);
  } finally {
    _allocator
      ..free(_header)
      ..free(_message);
  }
}
