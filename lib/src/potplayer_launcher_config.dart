import 'package:win32_registry/win32_registry.dart';

import 'protocol.dart' show protocol;

class PotPlayerLauncherConfig {
  const PotPlayerLauncherConfig({
    required this.potPlayerExecutablePath,
  });

  final String potPlayerExecutablePath;

  static const potPlayerExecutablePathValue = 'pp_executable';

  static RegistryKey _openProtocolKey() {
    final hkcr = Registry.openPath(
      RegistryHive.classesRoot,
      desiredAccessRights: AccessRights.allAccess,
    );
    if (!hkcr.subkeyNames.contains(protocol)) {
      throw Exception('Cannot find protocol key.');
    }
    try {
      return hkcr.createKey(protocol);
    } finally {
      hkcr.close();
    }
  }

  static PotPlayerLauncherConfig read() {
    final RegistryKey protocolKey = _openProtocolKey();
    try {
      final potPlayerExecutablePath = protocolKey.getValue(potPlayerExecutablePathValue);
      if (potPlayerExecutablePath == null || potPlayerExecutablePath.type != RegistryValueType.string) {
        throw Exception('Cannot read config.');
      }

      return PotPlayerLauncherConfig(
        potPlayerExecutablePath: potPlayerExecutablePath.data.toString(),
      );
    } finally {
      protocolKey.close();
    }
  }

  void write() {
    try {
      _openProtocolKey()
        ..createValue(
          RegistryValue(
            potPlayerExecutablePathValue,
            RegistryValueType.string,
            potPlayerExecutablePath,
          ),
        )
        ..close();
    } catch(e) {
      throw Exception('Cannot write config. Protocol isn\'t registered.');
    }
  }
}
