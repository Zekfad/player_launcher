import 'package:win32_registry/win32_registry.dart';

import '../../../protocol.dart';
import '../config.dart';
import 'registry_config.dart';


Config getPlatformConfig() {
  final hkcr = Registry.openPath(
    RegistryHive.classesRoot,
    desiredAccessRights: AccessRights.allAccess,
  );
  try {
    if (!hkcr.subkeyNames.contains(protocol))
      throw Exception('Cannot find protocol key.');

    final protocolKey = hkcr.createKey(protocol);
    try {
      final configKey = protocolKey.createKey('Config');
      return RegistryConfig.readSync(configKey);
    } finally {
      protocolKey.close();
    }
  } finally {
    hkcr.close();
  }
}
