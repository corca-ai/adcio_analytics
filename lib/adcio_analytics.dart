library adcio_analytics;

export 'package:adcio_analytics/src/adcio_log_option.dart';
import 'package:adcio_analytics/adcio_analytics.dart';
import 'package:adcio_analytics/src/api_client.dart';

class AdcioAnalytics {
  AdcioAnalytics._();

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
