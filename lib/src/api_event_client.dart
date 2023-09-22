import 'package:adcio_analytics/src/api_request.dart';
import 'package:adcio_analytics/src/error.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class PageViewApiClient extends ApiClient {
  PageViewApiClient({String? baseUrl}) : super(baseUrl: baseUrl);

  @override
  String get url => '${super.url}/view';
}

class ApiClient {
  ApiClient({String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://receiver.adcio.ai';

  final ApiRequest _request = ApiRequest(Client());
  final String _baseUrl;

  String get url => '$_baseUrl/events';

  Future<void> call({
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
