import 'package:win32_registry/win32_registry.dart';

import '../config.dart';
import '../config_section.dart';


base class RegistryConfig extends Config {
  const RegistryConfig(this.key, [this.sections = const []]);
  
  factory RegistryConfig.readSync(RegistryKey key) {
    final sections = <ConfigSection>[];

    // We're updating object, so cant use const immutable value
    // ignore: prefer_const_constructors
    var currentSection = ConfigSection('', {});

    void _readKeyValues(RegistryKey subKey) {
      for (final value in subKey.values) {
        final stringValue = switch (value) {
          StringValue(:final value) => value,
          Int32Value(:final value) || Int64Value(:final value) => value.toString(),
          _ => null,
        };
        if (null != stringValue)
          currentSection.values[value.name] = stringValue;
      }
    }

    _readKeyValues(key);

    final subKeyNames = key.subkeyNames.toList(growable: false);
    for (final subKeyName in subKeyNames) {
      sections.add(currentSection);
      currentSection = ConfigSection(subKeyName, {});
      final subKey = key.createKey(subKeyName);
      try {
        _readKeyValues(subKey);
      } finally {
        subKey.close();
      }
    }

    sections.add(currentSection);  

    return RegistryConfig(key, sections);
  }

  final RegistryKey key;

  @override
  final List<ConfigSection> sections;

  @override
  Future<void>? write() {
    var currentSubKey = key;

    void _writeKeyValues(ConfigSection section) {
      for (final entry in section.values.entries)
        currentSubKey.createValue(
          RegistryValue.string(
            entry.key,
            entry.value,
          ),
        );
    }

    for (final section in sections) {
      if (section.name.isNotEmpty) {
        if (currentSubKey != key)
          currentSubKey.close();
        currentSubKey = key.createKey(section.name);
      }
      _writeKeyValues(section);
    }
  }

  @override
  Future<void>? close() {
    key.close();
  }
}
