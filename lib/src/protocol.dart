import 'dart:io';

import 'package:win32/win32.dart';
import 'package:win32_registry/win32_registry.dart';

import 'recursive_delete_sub_key.dart';


const protocol = 'potplayer';
const protocolName = 'URL:PotPlayer launcher protocol';
const contentType = 'application/x-potplayer';

bool register(String potPlayerExecutablePath) {
  final executablePath = Platform.resolvedExecutable;

  final hkcr = Registry.openPath(
    RegistryHive.classesRoot,
    desiredAccessRights: AccessRights.allAccess,
  );
  if (hkcr.subkeyNames.contains(protocol)) {
    if (!recursiveDeleteSubKey(hkcr, protocol)) {
      throw Exception('Cannot delete existing protocol key. Try to run with admin rights.');
    }
  }

  try {

    final protocolKey = hkcr.createKey(protocol)
      ..createValue(
        const RegistryValue(
          '',
          RegistryValueType.string,
          'URL:PotPlayer launcher protocol',
        ),
      )
      ..createValue(
        const RegistryValue(
          'Content Type',
          RegistryValueType.string,
          contentType,
        ),
      )
      ..createValue(
        const RegistryValue(
          'URL Protocol',
          RegistryValueType.string,
          '',
        ),
      );

    final defaultIconKey = protocolKey.createKey('DefaultIcon')
      ..createValue(
        RegistryValue(
          '',
          RegistryValueType.string,
          '"$potPlayerExecutablePath", 1',
        ),
      );

    final shellKey = protocolKey.createKey('shell')
      ..createValue(
        const RegistryValue(
          '',
          RegistryValueType.string,
          'open',
        ),
      );

    final openKey = shellKey.createKey('open');

    final commandKey = openKey.createKey('command')
      ..createValue(
        RegistryValue(
          '',
          RegistryValueType.string,
          '"$executablePath" "%1"',
        ),
      );

    defaultIconKey.close();
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
