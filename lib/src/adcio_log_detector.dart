import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../adcio_analytics.dart';

class AdcioLogDetector extends StatelessWidget {
  /// Wrap the Widget that displays the recommended product
  /// from [adcio_placement](https://pub.dev/packages/adcio_placement) with an [AdcioLogDetector].
  ///
  /// This automatically triggers the onImpression logging event
  /// when the recommended product is displayed on the screen.
  ///
  /// Additionally, when the recommended product is clicked
  /// by the customer (similar to a client user), it triggers the onClick logging event.
  const AdcioLogDetector({
    super.key,
    required this.child,
    required this.option,
    this.baseUrl,
  });

  final Widget child;
  final AdcioLogOption option;
  final String? baseUrl;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: super.key ?? Key(option.adsetId),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction < 0.5) return;
        if (AdcioAnalytics.hasImpression(option.adsetId)) return;

        AdcioAnalytics.onImpression(
          option,
          baseUrl: baseUrl,
        );
      },
      child: GestureDetector(
        onTap: () => AdcioAnalytics.onClick(
          option,
          baseUrl: baseUrl,
        ),
        child: child,
      ),
    );
  }
}
