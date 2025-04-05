import 'players/iina/launch.dart' as iina_lib;
import 'players/launch_player_function.dart';
import 'players/potplayer/launch.dart' as pot_player_lib;

export 'players/launch_player_function.dart';

const LaunchPlayerFunction potPlayer = pot_player_lib.launch;
const LaunchPlayerFunction iina = iina_lib.launch;
