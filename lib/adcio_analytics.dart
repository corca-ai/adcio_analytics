library adcio_analytics;

export 'package:adcio_analytics/src/adcio_log_option.dart';
export 'package:adcio_analytics/src/adcio_impression_detector.dart';

import 'package:adcio_analytics/adcio_analytics.dart';
import 'package:adcio_analytics/src/api_client.dart';
import 'package:adcio_core/adcio_core.dart';

class AdcioAnalytics {

  AdcioAnalytics._();
  
  static init({required String clientId}) {
    _clientId = clientId;
  }

  static late String _clientId;
  static final _impressionHistory = <String>[];

  static bool hasImpression(String adsetId) =>
      _impressionHistory.contains(adsetId);

  static void clearImpressionHistory() => _impressionHistory.clear();

  /// click event log
  ///
  /// This event is called when a user clicks on a recommended product displayed on a suggestion placement.
  static void onClick({
    required AdcioLogOption option,
    String? sessionId,
    String? deviceId,
    String? customerId,
    String? baseUrl,
  }) async {
    ClickApiClient(baseUrl: baseUrl).callPerformance(
      sessionId: sessionId ?? SessionIdentifier().identifier,
      deviceId: deviceId ?? await DeviceIdentifier().identifier,
      storeId: _clientId,
      requestId: option.requestId,
      adsetId: option.adsetId,
      customerId: customerId,
    );
  }

  /// impression event log
  ///
  /// This event is called when a suggestion placement is displayed on the screen during the ad lifecycle (e.g., page lifecycle). This call occurs only once when the suggestion placement is revealed.
  static void onImpression({
    required AdcioLogOption option,
    String? sessionId,
    String? deviceId,
    String? customerId,
    String? baseUrl,
  }) async {
    _impressionHistory.add(option.adsetId);

    ImpressionApiClient(baseUrl: baseUrl).callPerformance(
      sessionId: sessionId ?? SessionIdentifier().identifier,
      deviceId: deviceId ?? await DeviceIdentifier().identifier,
      storeId: _clientId,
      requestId: option.requestId,
      adsetId: option.adsetId,
      customerId: customerId,
    );
  }

  /// purchase event log
  ///
  /// This event is called when a user purchases a recommended product.
  static void onPurchase({
    required String orderId,
    required String productIdOnStore,
    required int amount,
    String? sessionId,
    String? deviceId,
    String? customerId,
    String? baseUrl,
  }) async {
    PurchaseApiClient(baseUrl: baseUrl).callPurchaseEvent(
      sessionId: sessionId ?? SessionIdentifier().identifier,
      deviceId: deviceId ?? await DeviceIdentifier().identifier,
      storeId: _clientId,
      orderId: orderId,
      productIdOnStore: productIdOnStore,
      amount: amount,
      customerId: customerId,
    );
  }

  /// page view event log
  ///
  /// This event is called when a new screen is shown to the user.
  static void onPageView({
    required String path,
    String? sessionId,
    String? deviceId,
    String? title,
    String? customerId,
    String? productIdOnStore,
    String? referrer,
    String? baseUrl,
  }) async {
    PageViewApiClient(baseUrl: baseUrl).callPageViewEvent(
      sessionId: sessionId ?? SessionIdentifier().identifier,
      deviceId: deviceId ?? await DeviceIdentifier().identifier,
      storeId: _clientId,
      path: path,
      customerId: customerId,
      productIdOnStore: productIdOnStore,
      title: title ?? path,
      referrer: referrer,
    );
  }

  /// add to cart event log
  ///
  /// This event is called when the customer adds a product to the cart.
  static void onAddToCart({
    required String cartId,
    required String productIdOnStore,
    String? sessionId,
    String? deviceId,
    String? customerId,
    String? baseUrl,
  }) async {
    AddToCartApiClient(baseUrl: baseUrl).callAddToCartEvent(
      sessionId: sessionId ?? SessionIdentifier().identifier,
      deviceId: deviceId ?? await DeviceIdentifier().identifier,
      storeId: _clientId,
      cartId: cartId,
      productIdOnStore: productIdOnStore,
      customerId: customerId,
    );
  }
}
