import 'players/iina/launch.dart' as iinaLib;
import 'players/launch_player_function.dart';
import 'players/potplayer/launch.dart' as potPlayerLib;

export 'players/launch_player_function.dart';

const LaunchPlayerFunction potPlayer = potPlayerLib.launch;
const LaunchPlayerFunction iina = iinaLib.launch;
