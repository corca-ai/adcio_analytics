import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:adcio_analytics/models/log_option.dart';
import 'package:adcio_analytics/src/errors.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'env.dart';

/// ADCIO Analytics API.
///
/// ## usage
///
/// Once you call (AdcioAnalytics.init)
/// You may wish to prefix the import.
///
///     import 'package:adcio_analytics/adcio_analytics.dart';
///
///     void main() async {
///       await await AdcioAnalytics.init();
///       // ...
///     }
///
///     ...
///
///     class _MyHomePageState extends State<MyHomePage> {
///       final _option = LogOption(
///         requestId: 'requestId',
///         cost: 1000,
///         campaignId: 'campainId',
///         productId: 'productId',
///       );
///
///       void _onclick() {
///         AdcioAnalytics.clickLogEvent(option: _option);
///       }
///     }
///
class AdcioAnalytics {
  AdcioAnalytics._();

  static bool _isInitialized = false;
  static bool _isEmptyEnvFile = true;
  static late String _urlKey;
  static late String _sessionId;
  static final _ApiRequest _request = _ApiRequest(Client());

  static const _baseUrl = 'https://receiver.adcio.ai';
  static const _defaultEnvFileName = '.env';

  static String get sessionId => _sessionId;
  static get _url =>
      _isEmptyEnvFile ? (_baseUrl) : (Env.env[_urlKey] ?? _baseUrl);

  /// called only once during runtime.
  ///
  /// ## usage
  ///
  ///     void main() async {
  ///       await await AdcioAnalytics.init();
  ///     }
  static Future<void> init({
    String envFileName = _defaultEnvFileName,
    String urlKey = 'ROOT_DEV_URL',
  }) async {
    await _setEnv(envFileName);
    _urlKey = urlKey;
    _sessionId = await _setSessionId();
    _isInitialized = true;
  }

  static Future<void> _setEnv(String envFileName) async {
    try {
      await Env.load(fileName: envFileName);
      _isEmptyEnvFile = false;
    } on FileNotFoundError {
      _isEmptyEnvFile = true;
    }
  }

  static Future<String> _setSessionId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return info.id;
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return info.identifierForVendor ?? '${DateTime.now()}';
    } else {
      return '${DateTime.now()}';
    }
  }

  ///
  /// impression event log
  static Future<Map<String, dynamic>> impressionLogEvent({
    required LogOption option,
  }) async {
    if (!_isInitialized) {
      throw NotInitializedError();
    }

    final url = '$_url/performance/impression';
    final params = <String, dynamic>{};

    option.sessionId ??= sessionId;
    params.addAll(option.toJson);

    final response = await _request(
      method: _RequestMethod.post,
      url: url,
      params: params,
    );

    if (response.statusCode == 201) {
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

  ///
  /// click event log
  static Future<Map<String, dynamic>> clickLogEvent({
    required LogOption option,
  }) async {
    if (!_isInitialized) {
      throw NotInitializedError();
    }

    final url = '$_url/performance/click';
    final params = <String, dynamic>{};

    option.sessionId ??= sessionId;
    params.addAll(option.toJson);

    final response = await _request(
      method: _RequestMethod.post,
      url: url,
      params: params,
    );

    if (response.statusCode == 201) {
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

  ///
  /// purchase event log
  static Future<Map<String, dynamic>> purchaseLogEvent({
    required LogOption option,
  }) async {
    if (!_isInitialized) {
      throw NotInitializedError();
    }

    final url = '$_url/performance/purchase';
    final params = <String, dynamic>{};

    option.sessionId ??= sessionId;
    params.addAll(option.toJson);

    final response = await _request(
      method: _RequestMethod.post,
      url: url,
      params: params,
    );

    if (response.statusCode == 201) {
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

enum _RequestMethod { get, post }

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

    final httpResponse = await _requestHttp(
      method,
      headers ?? {'content-type': 'application/json'},
      url,
      params,
    );
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
      case _RequestMethod.post:
        result = _client.post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(params),
        );
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
