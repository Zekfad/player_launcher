


import 'dart:io';

import '../../config.dart';
import '../../player_arguments.dart';
import 'find_pot_player_executable.dart';
import 'launch_potplayer.dart';
import 'pot_player_launch_arguments.dart';


void launch(Config config, PlayerArguments playerArguments) {
  if (!Platform.isWindows)
    throw UnsupportedError('PotPlayer is Windows only player.');

  final _config = config['potplayer']?.values;

  final potPlayerExecutable = _config?['Executable'] ?? findPotPlayerExecutable();

  if (potPlayerExecutable == null)
    throw Exception('PotPlayer executable not found.\nTry to set "Executable" option in "potplayer" config section.');

  final currentInstance = bool.tryParse(_config?['CurrentInstance'] ?? '') ?? true;

  return launchPotPlayer(
    potPlayerExecutable,
    PotPlayerLaunchArguments(
      contents: [ playerArguments.video.toString(), ],
      subtitle: playerArguments.subtitles?.toString(),
      currentInstance: currentInstance,
    ),
  );
} 
