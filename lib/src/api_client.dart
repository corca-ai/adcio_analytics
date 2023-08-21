import 'package:adcio_analytics/src/api_request.dart';
import 'package:adcio_analytics/src/error.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class ClickApiClient extends ApiClient {
  ClickApiClient({String? baseUrl}) : super(baseUrl: baseUrl);

  @override
  String get url => '${super.url}/click';
}

class PurchaseApiClient extends ApiClient {
  PurchaseApiClient({String? baseUrl}) : super(baseUrl: baseUrl);

  @override
  String get url => '${super.url}/purchase';
}

class ImpressionApiClient extends ApiClient {
  ImpressionApiClient({String? baseUrl}) : super(baseUrl: baseUrl);

  @override
  String get url => '${super.url}/impression';
}

class ApiClient {
  ApiClient({String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://receiver.adcio.ai';

  final ApiRequest _request = ApiRequest(Client());
  final String _baseUrl;

  String get url => '$_baseUrl/performance';

  Future<void> call({
    required String requestId,
    required String adsetId,
  }) async {
    final params = <String, dynamic>{};
    params['requestId'] = requestId;
    params['adsetId'] = adsetId;

    final response = await _request(
      method: RequestMethod.post,
      url: url,
      params: params,
    );

    if (response.statusCode == 200) {
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
