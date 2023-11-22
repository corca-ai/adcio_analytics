import 'package:adcio_analytics/src/api_request.dart';
import 'package:adcio_analytics/src/error.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class ClickApiClient extends ApiClient {
  ClickApiClient({String? baseUrl}) : super(baseUrl: baseUrl);

  @override
  String get url => '${super.url}/performance/click';
}

class ImpressionApiClient extends ApiClient {
  ImpressionApiClient({String? baseUrl}) : super(baseUrl: baseUrl);

  @override
  String get url => '${super.url}/performance/impression';
}

class PurchaseApiClient extends ApiClient {
  PurchaseApiClient({String? baseUrl}) : super(baseUrl: baseUrl);

  @override
  String get url => '${super.url}/events/purchase';
}

class PageViewApiClient extends ApiClient {
  PageViewApiClient({String? baseUrl}) : super(baseUrl: baseUrl);

  @override
  String get url => '${super.url}/events/view';
}

class AddToCartApiClient extends ApiClient {
  AddToCartApiClient({String? baseUrl}) : super(baseUrl: baseUrl);

  @override
  String get url => '${super.url}/events/add-to-cart';
}

class ApiClient {
  ApiClient({String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://receiver.adcio.ai';

  final ApiRequest _request = ApiRequest(Client());
  final String _baseUrl;

  String get url => _baseUrl;

  Future<void> callPerformance({
    required String sessionId,
    required String deviceId,
    required String storeId,
    required String requestId,
    required String adsetId,
    String? customerId,
  }) async {
    final params = <String, dynamic>{};
    params['sessionId'] = sessionId;
    params['deviceId'] = deviceId;
    params['storeId'] = storeId;
    params['requestId'] = requestId;
    params['adsetId'] = adsetId;
    if (customerId != null) params['customerId'] = customerId;

    return _handlePostRequest(params);
  }

  Future<void> callPageViewEvent({
    required String sessionId,
    required String deviceId,
    required String storeId,
    required String path,
    String? customerId,
    String? productIdOnStore,
    String? title,
    String? referrer,
  }) async {
    final params = <String, dynamic>{};
    params['sessionId'] = sessionId;
    params['deviceId'] = deviceId;
    params['storeId'] = storeId;
    params['path'] = path;
    if (customerId != null) params['customerId'] = customerId;
    if (productIdOnStore != null) params['productIdOnStore'] = productIdOnStore;
    if (title != null) params['title'] = title;
    if (referrer != null) params['referrer'] = referrer;

    return _handlePostRequest(params);
  }

  Future<void> callPurchaseEvent({
    required String sessionId,
    required String deviceId,
    required String storeId,
    required String orderId,
    required String productIdOnStore,
    required int amount,
    String? customerId,
  }) async {
    final params = <String, dynamic>{};
    params['sessionId'] = sessionId;
    params['deviceId'] = deviceId;
    params['storeId'] = storeId;
    params['orderId'] = orderId;
    params['productIdOnStore'] = productIdOnStore;
    params['amount'] = amount;
    if (customerId != null) params['customerId'] = customerId;

    return _handlePostRequest(params);
  }

  Future<void> callAddToCartEvent({
    required String sessionId,
    required String deviceId,
    required String cartId,
    required String storeId,
    required String productIdOnStore,
    String? customerId,
  }) async {
    final params = <String, dynamic>{};
    params['sessionId'] = sessionId;
    params['deviceId'] = deviceId;
    params['cartId'] = cartId;
    params['storeId'] = storeId;
    params['productIdOnStore'] = productIdOnStore;
    if (customerId != null) params['customerId'] = customerId;

    return _handlePostRequest(params);
  }

  Future<void> _handlePostRequest(Map<String, dynamic> params) async {
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
