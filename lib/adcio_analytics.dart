library adcio_analytics;

export 'package:adcio_analytics/src/adcio_log_option.dart';
export 'package:adcio_analytics/src/adcio_impression_detector.dart';
import 'package:adcio_analytics/adcio_analytics.dart';
import 'package:adcio_analytics/src/api_client.dart';

class AdcioAnalytics {
  AdcioAnalytics._();
  static final _impressionHistory = <String>[];

  static bool hasImpression(String adsetId) =>
      _impressionHistory.contains(adsetId);

  static void clearImpressionHistory() => _impressionHistory.clear();

  /// click event log
  ///
  /// This event is called when a user clicks on a recommended product displayed on a suggestion placement.
  static void onClick(
    AdcioLogOption option, {
    String? baseUrl,
  }) {
    ClickApiClient(baseUrl: baseUrl).call(
      requestId: option.requestId,
      adsetId: option.adsetId,
    );
  }

  /// impression event log
  ///
  /// This event is called when a suggestion placement is displayed on the screen during the ad lifecycle (e.g., page lifecycle). This call occurs only once when the suggestion placement is revealed.
  static void onImpression(
    AdcioLogOption option, {
    String? baseUrl,
  }) {
    _impressionHistory.add(option.adsetId);

    ImpressionApiClient(baseUrl: baseUrl).call(
      requestId: option.requestId,
      adsetId: option.adsetId,
    );
  }

  /// purchase event log
  ///
  /// This event is called when a user purchases a recommended product.
  static void onPurchase(
    AdcioLogOption option, {
    required int amount,
    String? baseUrl,
  }) {
    PurchaseApiClient(baseUrl: baseUrl).call(
      requestId: option.requestId,
      adsetId: option.adsetId,
      amount: amount,
    );
  }
}
