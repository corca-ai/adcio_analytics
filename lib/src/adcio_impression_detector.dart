import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../adcio_analytics.dart';

class AdcioImpressionDetector extends StatelessWidget {
  /// Wrap the Widget that displays the recommended product
  /// from [adcio_placement](https://pub.dev/packages/adcio_placement) with an [AdcioImpressionDetector].
  ///
  /// This automatically triggers the onImpression logging event
  /// when the recommended product is displayed on the screen.
  const AdcioImpressionDetector({
    super.key,
    required this.child,
    required this.option,
    required this.clientId,
    this.baseUrl,
  });

  final Widget child;
  final AdcioLogOption option;
  final String? baseUrl;
  final String clientId;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: super.key ?? Key(option.adsetId),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction < 0.5) return;
        if (AdcioAnalytics.hasImpression(option.adsetId)) return;

        AdcioAnalytics(clientId).onImpression(
          option: option,
          baseUrl: baseUrl,
        );
      },
      child: child,
    );
  }
}
