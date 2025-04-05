import 'dart:io';

import 'package:win32_registry/win32_registry.dart';

import '../protocol.dart';

const protocolName = 'URL:Player launcher protocol';
const contentType = 'application/x-player-launcher';

bool registerProtocol([String? defaultIcon]) {
  final executablePath = Platform.resolvedExecutable;

  final hkcr = Registry.openPath(
    RegistryHive.classesRoot,
    desiredAccessRights: AccessRights.allAccess,
  );
  if (hkcr.subkeyNames.contains(protocol)) {
    try {
      hkcr.deleteKey(protocol, recursive: true);
    } catch (e) {
      throw Exception('Cannot delete existing protocol key. Try to run with admin rights.');
    }
  }

  try {
    final protocolKey = hkcr.createKey(protocol)
      ..createValue(
        const RegistryValue.string(
          '',
          protocolName,
        ),
      )
      ..createValue(
        const RegistryValue.string(
          'Content Type',
          contentType,
        ),
      )
      ..createValue(
        const RegistryValue.string(
          'URL Protocol',
          '',
        ),
      );

    protocolKey.createKey('Config').close();

    final shellKey = protocolKey.createKey('shell')
      ..createValue(
        const RegistryValue.string(
          '',
          'open',
        ),
      );

    final openKey = shellKey.createKey('open');

    final commandKey = openKey.createKey('command')
      ..createValue(
        RegistryValue.string(
          '',
          '"$executablePath" "%1"',
        ),
      );

    if (defaultIcon != null) {
      protocolKey.createKey('DefaultIcon')
        ..createValue(
          RegistryValue.string(
            '',
            defaultIcon,
          ),
        )
        ..close();
    }

    commandKey.close();
    openKey.close();
    shellKey.close();
    protocolKey.close();
  } catch (e) {
    throw Exception('Cannot register protocol.');
  } finally {
    hkcr.close();
  }
  return true;
}
