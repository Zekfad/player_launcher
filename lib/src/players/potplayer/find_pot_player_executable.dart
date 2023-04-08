import 'package:win32_registry/win32_registry.dart';


String? findPotPlayerExecutable() {
  try {
    final potrunKey = Registry.openPath(
      RegistryHive.classesRoot,
      path: r'potrun\shell\open\command',
      desiredAccessRights: AccessRights.readOnly,
    );
    final potrun = potrunKey.getValueAsString('');
    if (potrun?.endsWith(' "%1"') ?? false) {
      return potrun!.substring(0, potrun.length - 5);
    }
  } catch(e) {
    // ignore
  }

  return null;
}
