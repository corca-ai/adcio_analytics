import 'dart:convert';
import 'dart:developer';

import 'package:adcio_analytics/models/log_option.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class AdcioAnalytics {
  AdcioAnalytics._();

  static bool _isInitialized = false;
  static final _ApiRequest _request = _ApiRequest(Client());

  static Future<void> init() async {
    log('init S');
    await dotenv.load(fileName: '.env');
    _isInitialized = true;
    log('init E');
  }

  static Future<Map<String, dynamic>> clickLogEvent({
    required LogOption option,
  }) async {
    if (!_isInitialized) {
      throw PlatformException(
        code: 'NotInitialzed_AdcioAnalytics',
      );
    }

    final url = '${dotenv.env['ROOT_DEV_URL'] ?? ''}/ads/click';
    final params = <String, dynamic>{};

    params.addAll(option.toJson);

    final response = await _request(
      method: _RequestMethod.get,
      url: url,
      params: params,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw PlatformException(
        code: 'SYSTEM_ERROR',
        details: {
          'statusCode': response.statusCode,
          'body': response.body ?? '',
        },
      );
    }
  }
}

enum _RequestMethod { get }

class _ApiRequest {
  _ApiRequest(Client client) : _client = client;

  final Client _client;

  Future<_ApiResponse> call({
    required _RequestMethod method,
    Map<String, String>? headers,
    required String url,
    Map<String, dynamic>? params,
  }) async {
    log('[req] $method $url (${params ?? ''})');
    final httpResponse = await _requestHttp(method, headers, url, params);
    final response = _ApiResponse.fromHttpResponse(httpResponse);
    log('[res] $method $url ${response.statusCode} ${response.body}');
    return response;
  }

  Future<Response> _requestHttp(
    _RequestMethod method,
    Map<String, String>? headers,
    String url,
    Map<String, dynamic>? params,
  ) {
    Future<Response> result;
    switch (method) {
      case _RequestMethod.get:
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
    return params.entries.map((e) => '${e.key}=${e.value}').join('&');
  }
}

class _ApiResponse {
  _ApiResponse({required this.statusCode});

  int statusCode;
  dynamic body;

  factory _ApiResponse.fromHttpResponse(Response res) {
    final response = _ApiResponse(statusCode: res.statusCode);

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
