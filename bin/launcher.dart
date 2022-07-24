import 'dart:convert' show jsonDecode;
import 'dart:io';

import 'package:potplayer_launcher/potplayer_launcher.dart';
import 'package:potplayer_launcher/protocol.dart' as protocol;

T? cast<T>(dynamic json) => json is T? ? json : null; 

void main(List<String> arguments) async {
  try {
    if (arguments.isEmpty)
      throw ArgumentError.value(arguments.length, 'Missing arguments.');
    if (arguments.length == 1 && arguments.first.startsWith(protocol.protocol)) {
      runPotPlayerUri(arguments.first);
    } else if (arguments.first == '--register' && arguments.length >= 2) {
      final potPlayerExecutablePath = arguments[1];

      if (!File(potPlayerExecutablePath).existsSync())
        throw ArgumentError.value(potPlayerExecutablePath, 'Bad executable path.');

      protocol.register(potPlayerExecutablePath);

      PotPlayerLauncherConfig(
        potPlayerExecutablePath: potPlayerExecutablePath,
      ).write();
    } else {
      stdout
        ..writeln('launcher [launch-uri|--help|--register <executable>]\n')
        ..writeln(' launch-uri              - launch PotPlayer with required parameters from URI')
        ..writeln(' --register <executable> - register protocol in system with pot player executable')
        ..writeln(' --help                  - show this help page');
      await stdout.flush();
    }
  } catch (e) {
    stderr.writeln(e);
    await stderr.flush();
    Future.delayed(const Duration(seconds: 5), (){});
  }
}

void runPotPlayerUri(String uriString) {
  final config = PotPlayerLauncherConfig.read();

  final uri = Uri.tryParse(uriString);
  if (uri == null)
    throw ArgumentError.value(uriString, 'Invalid URI.');
  if (uri.scheme != protocol.protocol)
    throw ArgumentError.value(uri.scheme, 'Invalid protocol.');
  
  String query = uri.query;
  final dynamic json;
  try {
    query = Uri.decodeComponent(query);
    json = jsonDecode(query);
  } catch(e) {
    throw ArgumentError.value(query, 'Invalid JSON.');
  }
  
  final url = cast<String>(json?['url']);
  final subtitle = cast<String>(json?['subtitle']);
  
  if (url == null)
    throw ArgumentError.value(json, 'Missing URL.');
  
  launchPotPlayer(
    config.potPlayerExecutablePath,
    PotPlayerLaunchArguments(
      contents: [
        url,
      ],
      subtitle: subtitle,
      currentInstance: true,
    ),
  );
}
