import 'dart:io';

import 'all/get_platform_config.dart' as all;
import 'config.dart';
import 'stub/get_platform_config.dart' as stub;
import 'win/get_platform_config.dart' as win;


Config getPlatformConfig() {
  if (Platform.isWindows)
    return win.getPlatformConfig();
  if (Platform.isMacOS || Platform.isLinux)
    return all.getPlatformConfig();
  return stub.getPlatformConfig();
}
