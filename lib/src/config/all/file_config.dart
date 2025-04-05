import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../config.dart';
import '../config_section.dart';


base class FileConfig extends Config {
  const FileConfig(this.file, [ this.sections = const [], ]);

  factory FileConfig.readSync(File file, {Encoding encoding = utf8}) {
    final sections = <ConfigSection>[];
    final lines = file.readAsLinesSync(encoding: encoding);

    // We're updating object, so cant use const immutable value
    // ignore: prefer_const_constructors
    var currentSection = ConfigSection('', {});
    final sectionRegex = RegExp(r'^\[(?<name>.+)\]$');
    final keyValueRegex = RegExp(r'^(?<key>[^ ]+) *= *(?<value>[^ \n\r]+) *$');

    for (final line in lines) {
      final sectionMatch = sectionRegex.firstMatch(line);
      if (sectionMatch != null) {
        final name = sectionMatch.namedGroup('name')!;
        sections.add(currentSection);
        currentSection = ConfigSection(name, {});
        continue;
      }
      final keyValueMatch = keyValueRegex.firstMatch(line);
      if (keyValueMatch != null) {
        final key = keyValueMatch.namedGroup('key')!;
        final value = keyValueMatch.namedGroup('value')!;
        currentSection.values[key] = value;
        continue;
      }
    }
  
    sections.add(currentSection);

    return FileConfig(file, sections);
  }

  final File file;

  @override
  final List<ConfigSection> sections;

  @override
  Future<void>? write() async {
    final sink = file.openWrite();
    for (final section in sections) {
      if (section.name.isNotEmpty)
        sink.writeln('\n[${section.name}]');
      for (final entry in section.values.entries)
        sink.writeln('${entry.key} = ${entry.value}');
    }
    await sink.flush();
    return sink.close();
  }

  @override
  Future<void>? close() {}
}
