import 'package:win32_registry/win32_registry.dart';


bool recursiveDeleteSubKey(RegistryKey rootKey, String keyName) {
  try {
    rootKey.deleteKey(keyName);
    return true;
  } catch(e) {
    final key = rootKey.createKey(keyName);

    for (final subKeyName in key.subkeyNames.toList()) {
      if (!recursiveDeleteSubKey(key, subKeyName))
        return false;
    }

    key.close();

    try {
      rootKey.deleteKey(keyName);
      return true;
    } catch(e) {
      return false;
    }
  }
}
