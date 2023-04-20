import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'dart:io';

import 'package:path/path.dart';
import 'package:player_launcher/libalert.dart' as libalert;
import 'package:player_launcher/player_launcher.dart';
import 'package:player_launcher/players.dart' as players;
import 'package:player_launcher/registry_protocol.dart' as registry;


T? cast<T>(dynamic json) => json is T? ? json : null; 
void main(List<String> arguments) async {
  var uriMode = false;
  try {
    if (arguments.isNotEmpty) {
      if (arguments.length == 1 && arguments.single.startsWith(registry.protocol)) {
        uriMode = true;
        await runPlayerUri(arguments.first);
      } else if (arguments.first == '--register') {
        if (!Platform.isWindows)
          throw UnsupportedError('Unsupported platform.');

        registry.registerProtocol();
        stdout.writeln('Successfully registered protocol.');
        if (arguments.length > 1) {
          final path = normalize(arguments[1]);
          if (!File(path).existsSync())
            throw Exception('Invalid path, file doesn\'t exist.');

          final config = getPlatformConfig();
          final potPlayerConfig = config.getOrCreateSection('potplayer');
          potPlayerConfig.values['location'] = path;
          await config.write();
          stdout.writeln('Successfully saved PotPlayer location ($path).');
        } else {
          stderr.writeln('Warning: no PotPlayer path provided. Launcher will try to find it automatically.');
        }
      } else {
        await (stdout
          ..writeln('launcher (launch-uri|--help|--register [<executable>])\n')
          ..writeln(' launch-uri                - launch player with required parameters from URI')
          ..writeln(' --register [<executable>] - (windows only) register protocol in system with player executable')
          ..writeln('                             you can omit executable to try automatically find it')
          ..writeln(' --help                    - show this help page')
        ).flush();
      }
    }
  } catch (e) {
    if (Platform.isMacOS) {
      libalert.alert(
        'Error',
        e.toString(),
        libalert.AlertLevel.stop,
      );
    } else {
      await (stderr
        ..writeln(e)
      ).flush();

      if (uriMode) // Wait for 5 secs to show protocol handling error.
        Future.delayed(const Duration(seconds: 5), () {});
    }
  }
}

FutureOr<void> runPlayerUri(String uriString) async {
  final config = getPlatformConfig();

  final uri = Uri.tryParse(uriString);
  if (uri == null)
    throw ArgumentError.value(uriString, 'Invalid URI.');
  if (uri.scheme != registry.protocol)
    throw ArgumentError.value(uri.scheme, 'Invalid protocol.');
  
  final version = int.tryParse(uri.queryParameters['v'] ?? '1');
  final payload = uri.queryParameters['payload'];

  if (version == null || version < 2)
    throw Exception('Unsupported protocol version.');
  if (payload == null)
    throw Exception('Missing payload.');

  final dynamic json;
  try {
    json = jsonDecode(payload);
  } catch(e) {
    throw ArgumentError.value(payload, 'Invalid JSON.');
  }
  
  final video = Uri.tryParse(cast<String>(json?['video']) ?? '::invalid::');
  final subtitles = Uri.tryParse(cast<String>(json?['subtitles']) ?? '::invalid::');
  
  if (video == null)
    throw ArgumentError.value(json, 'Missing URL.');
  
  final players.LaunchPlayerFunction launchPlayerFunction;
  if (Platform.isWindows)
    launchPlayerFunction = players.potPlayer;
  else if (Platform.isMacOS)
    launchPlayerFunction = players.iina;
  else
    throw UnsupportedError('Unsupported platform.');

  return launchPlayerFunction(
    config,
    PlayerArguments(
      video    : video,
      subtitles: subtitles,
    ),
  );
}
