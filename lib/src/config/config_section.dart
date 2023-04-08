class ConfigSection {
  const ConfigSection(this.name, this.values);

  final String name;
  final Map<String, String> values;

  @override
  String toString() => 'ConfigSection ($values)';
}
