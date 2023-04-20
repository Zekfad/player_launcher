import 'dart:async';

import '../config/config.dart';
import '../player_arguments.dart';


typedef LaunchPlayerFunction = FutureOr<void> Function(Config config, PlayerArguments playerArguments);
