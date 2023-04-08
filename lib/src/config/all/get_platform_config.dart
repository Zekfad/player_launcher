import 'dart:io';

import 'package:path/path.dart' as path;

import '../config.dart';
import 'file_config.dart';


Config getPlatformConfig() {
  final executablePath = Platform.resolvedExecutable;
  var configDirectory = Platform.environment['HOME']
    ?? Platform.environment['UserProfile']
    ?? path.dirname(executablePath);

  if (Platform.isMacOS)
    configDirectory = path.join(configDirectory, 'Library/Application Support/Player Launcher');
  else
    configDirectory = path.join(configDirectory, '.player-launcher');

  final configPath = path.join(configDirectory, 'config.conf');
  final configFile = File(configPath);
  return FileConfig.readSync(
    configFile..createSync(
      recursive: true,
      exclusive: false,
    ),
  );
}
