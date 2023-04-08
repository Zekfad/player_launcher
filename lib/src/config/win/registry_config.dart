import 'dart:async';

import 'package:win32_registry/win32_registry.dart';

import '../config.dart';
import '../config_section.dart';


base class RegistryConfig extends Config {
  const RegistryConfig(this.key, [this.sections = const []]);
  
  factory RegistryConfig.readSync(RegistryKey key) {
    final sections = <ConfigSection>[];

    // ignore: prefer_const_constructors
    var currentSection = ConfigSection('', {});

    void _readKeyValues(RegistryKey subKey) {
      for (final value in subKey.values) {
        if (value.type == RegistryValueType.string)
          currentSection.values[value.name] = value.data as String;
        if (value.type == RegistryValueType.int32 || value.type == RegistryValueType.int64)
          currentSection.values[value.name] = (value.data as int).toString();
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
  FutureOr<void> write() {
    var currentSubKey = key;

    void _writeKeyValues(ConfigSection section) {
      for (final entry in section.values.entries)
        currentSubKey.createValue(
          RegistryValue(
            entry.key,
            RegistryValueType.string,
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
  void close() => key.close();
}
