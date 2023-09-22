import 'package:adcio_analytics/src/api_request.dart';
import 'package:adcio_analytics/src/error.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class ClickApiClient extends ApiClient {
  ClickApiClient({String? baseUrl}) : super(baseUrl: baseUrl);

  @override
  String get url => '${super.url}/performance/click';
}

class PurchaseApiClient extends ApiClient {
  PurchaseApiClient({String? baseUrl}) : super(baseUrl: baseUrl);

  @override
  String get url => '${super.url}/performance/purchase';
}

class ImpressionApiClient extends ApiClient {
  ImpressionApiClient({String? baseUrl}) : super(baseUrl: baseUrl);

  @override
  String get url => '${super.url}/performance/impression';
}

class PageViewApiClient extends ApiClient {
  PageViewApiClient({String? baseUrl}) : super(baseUrl: baseUrl);

  @override
  String get url => '${super.url}/events/view';
}

class ApiClient {
  ApiClient({String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://receiver.adcio.ai';

  final ApiRequest _request = ApiRequest(Client());
  final String _baseUrl;

  String get url => _baseUrl;

  Future<void> callPerformance({
    required String requestId,
    required String adsetId,
    int? amount,
  }) async {
    final params = <String, dynamic>{};
    params['requestId'] = requestId;
    params['adsetId'] = adsetId;
    if (amount != null) params['amount'] = amount;

    return handlePostRequest(params);
  }

  Future<void> callEvent({
    required String sessionId,
    required String deviceId,
    required String storeId,
    required String path,
    String? customerId,
    String? productCode,
    String? title,
    String? referrer,
  }) async {
    final params = <String, dynamic>{};
    params['sessionId'] = sessionId;
    params['deviceId'] = deviceId;
    params['storeId'] = storeId;
    params['path'] = path;
    if (customerId != null) params['customerId'] = customerId;
    if (productCode != null) params['productCode'] = productCode;
    if (title != null) params['title'] = title;
    if (referrer != null) params['referrer'] = referrer;

    return handlePostRequest(params);
  }

  Future<void> handlePostRequest(Map<String, dynamic> params) async {
    final response = await _request(
      method: RequestMethod.post,
      url: url,
      params: params,
    );

    if ([200, 201].contains(response.statusCode)) {
      return;
    } else if (response.statusCode == 400) {
      throw UnregisteredIdException();
    } else if (response.statusCode == 500) {
      throw ServerError();
    } else {
      throw PlatformException(
        code: 'UNKNOWN_ERROR',
        details: {
          'statusCode': response.statusCode,
          'body': response.body ?? '',
        },
      );
    }
  }
}
