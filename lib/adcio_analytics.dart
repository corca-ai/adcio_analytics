library adcio_analytics;

export 'package:adcio_analytics/src/adcio_log_option.dart';
export 'package:adcio_analytics/src/adcio_log_detector.dart';
import 'package:adcio_analytics/adcio_analytics.dart';
import 'package:adcio_analytics/src/api_client.dart';

class AdcioAnalytics {
  AdcioAnalytics._();
  static final _impressionHistory = <String>[];

  static bool hasImpression(String adsetId) =>
      _impressionHistory.contains(adsetId);

  static void clearImpressionHistory() => _impressionHistory.clear();

  /// click event log
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
