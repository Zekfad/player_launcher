import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';

const _serverPort = 13370;
const _invalidUri = '::Not valid URI::';

extension UriHasOrigin on Uri {
  bool get hasOrigin => (scheme == 'http' || scheme == 'https') && host != '';
}

/// Adds CORS headers to [response]
void _addCORSHeaders(HttpRequest request, HttpResponse response) {
  final refererUri = Uri.tryParse(
    request.headers[HttpHeaders.refererHeader]?.singleOrNull ?? _invalidUri,
  );
  response.headers
    ..add(
      HttpHeaders.accessControlAllowOriginHeader,
      (refererUri != null && refererUri.hasOrigin)
        ? refererUri.origin
        : '*',
    )
    ..add(
      HttpHeaders.accessControlAllowMethodsHeader,
      request.headers[HttpHeaders.accessControlRequestMethodHeader]?.join(',')
        ?? '*',
    )
    ..add(
      HttpHeaders.accessControlAllowHeadersHeader,
      request.headers[HttpHeaders.accessControlRequestHeadersHeader]?.join(',')
        ?? 'authorization,*',
    )
    ..add(
      HttpHeaders.accessControlAllowCredentialsHeader,
      'true',
    );
}

Future<Uri> listenForWrappedProtocolCall() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, _serverPort);

  final completer = Completer<Uri>();

  server.listen((request) {
    final response = request.response;
    _addCORSHeaders(request, response);

    // Handle preflight
    if (
      request.method.toUpperCase() == 'OPTIONS' &&
      request.headers[HttpHeaders.accessControlRequestMethodHeader] != null
    ) {
      response
        ..contentLength = 0
        ..statusCode = HttpStatus.ok
        ..close();
      return;
    }
    server.close().then((_) {
      final _uri = request.uri.queryParameters['uri'];
      final uri = Uri.tryParse(_uri ?? _invalidUri);

      response.contentLength = 0;
      if (uri == null) {
        completer.completeError(Exception('Bad request.'));
        response.statusCode = HttpStatus.badRequest;
      } else {
        completer.complete(uri);
        response.statusCode = HttpStatus.ok;
      }
      return response.close();
    });
  });

  return completer.future.timeout(
    const Duration(seconds: 1),
    onTimeout: () async {
      await server.close(force: true);
      throw TimeoutException('Server listening timeout.');
    },
  );
}
