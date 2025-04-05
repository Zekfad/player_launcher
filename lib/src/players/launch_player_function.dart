import 'dart:async';

import '../config/config.dart';
import '../player_arguments.dart';


typedef LaunchPlayerFunction = Future<void>? Function(Config config, PlayerArguments playerArguments);
