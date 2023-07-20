import 'package:adcio_analytics/adcio_analytics.dart';
import 'package:adcio_analytics/src/errors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'call event int not initialized',
    () {
      expect(
          AdcioAnalytics.clickLogEvent(
            option: LogOption(
              requestId: 'requestId',
              cost: 1000,
              campaignId: 'campaignId',
              productId: 'productId',
            ),
          ),
          isA<NotInitializedError>());
    },
  );

  test(
    'call event int initialized',
    () {
      AdcioAnalytics.init();
      expect(
        AdcioAnalytics.clickLogEvent(
          option: LogOption(
              requestId: 'requestId',
              cost: 1000,
              campaignId: 'campaignId',
              productId: 'productId'),
        ),
        {'success': 'true'},
      );
    },
  );
}
