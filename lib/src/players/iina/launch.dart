


import 'dart:io';

import '../../config.dart';
import '../../player_arguments.dart';


Future<void> launch(Config config, PlayerArguments playerArguments) {
  if (!Platform.isMacOS)
    throw UnsupportedError('IINA is MacOS only player.');

  final _config = config['iina']?.values;
  final iinaCliExecutable = _config?['Executable'] ?? '/Applications/IINA.app/Contents/MacOS/iina-cli';

  if (!File(iinaCliExecutable).existsSync())
    throw Exception('IINA CLI executable not found.\nTry to set "Executable" option in "iina" config section.');

  return Process.start(iinaCliExecutable, [
    playerArguments.video.toString(),
    '--mpv-sub-files-append=${playerArguments.subtitles}'
  ]);
}
