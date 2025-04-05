import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';

import 'config_section.dart';


abstract base class Config with MapMixin<String, ConfigSection> implements Map<String, ConfigSection> {
  const Config();

  List<ConfigSection> get sections;

  Future<void>? write();

  Future<void>? close();

  int _indexOfSection(Object? key) => 
    sections.indexWhere((element) => element.name == key);

  @override
  ConfigSection? operator [](Object? key) =>
    sections.firstWhereOrNull((element) => element.name == key);
  
  @override
  void operator []=(String key, ConfigSection value) {
    if (key != value.name)
      throw ArgumentError.value(value, 'value', 'Config section must have the same name as the key.');

    final index = _indexOfSection(key);
    if (index == -1)
      sections.add(value);
    else
      sections[index] = value;
  }
  
  @override
  void clear() => sections.clear();
  
  @override
  Iterable<String> get keys => sections.map((element) => element.name);
  
  @override
  ConfigSection? remove(Object? key) {
    final index = _indexOfSection(key);
    if (index != -1)
      return sections.removeAt(index);
  }

  ConfigSection requireSection(String name) {
    final section = this[name];
    if (section == null)
      throw StateError('Missing required section: $name');
    return section;
  }

  ConfigSection getOrCreateSection(String name) {
    final section = this[name];
    if (section == null)
      return this[name] = ConfigSection(name, {});
    return section;
  }

  @override
  String toString() => 'Config (${super.toString()})';
}
