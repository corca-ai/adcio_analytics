import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

enum RequestMethod { get, post }

class ApiRequest {
  ApiRequest(Client client) : _client = client;

  final Client _client;

  Future<ApiResponse> call({
    required RequestMethod method,
    Map<String, String>? headers = const {'content-type': 'application/json'},
    required String url,
    Map<String, dynamic>? params,
  }) async {
    log('[req] $method $url (${params ?? ''})');
    final httpResponse = await _requestHttp(method, headers, url, params);
    final response = ApiResponse.fromHttpResponse(httpResponse);
    log('[res] $method $url ${response.statusCode} ${response.body}');
    return response;
  }

  Future<Response> _requestHttp(
    RequestMethod method,
    Map<String, String>? headers,
    String url,
    Map<String, dynamic>? params,
  ) {
    Future<Response> result;
    switch (method) {
      case RequestMethod.post:
        result = _client.post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(params),
        );
      case RequestMethod.get:
        if (params?.isNotEmpty ?? false) {
          url += '?${_queryParameters(params!)}';
        }
        result = _client.get(
          Uri.parse(url),
          headers: headers,
        );
        break;
    }

    return result;
  }

  String _queryParameters(Map<String, dynamic> params) {
    return params.entries.map((json) {
      if (json.value is! Iterable) {
        return '${json.key}=${json.value}';
      }

      return (json.value as Iterable)
          .map((value) => '${json.key}=$value')
          .join('&');
    }).join('&');
  }
}

class ApiResponse {
  ApiResponse({required this.statusCode});

  int statusCode;
  dynamic body;

  factory ApiResponse.fromHttpResponse(Response res) {
    final response = ApiResponse(statusCode: res.statusCode);

    if (res.body.isNotEmpty) {
      final decodeData = utf8.decode(res.bodyBytes);
      response.body = jsonDecode(decodeData);
    }
    return response;
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'body': body,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
