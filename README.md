#  adcio_analytics
[![pub package](https://img.shields.io/pub/v/adcio_analytics.svg)](https://pub.dev/packages/adcio_analytics)

Flutter plugin that collects logs for event analysis of ADCIO projects.

To learn more about ADCIO, please visit the [ADCIO website](https://www.adcio.ai/)

## Getting Started
To get started with ADCIO account, please register [ADCIO account](https://app.adcio.ai/en/)

## Usage
There is a simple use example:
```dart
import 'package:adcio_analytics/adcio_analytics.dart';

final option = AdcioLogOption.fromMap(suggestion.logOptions);

onTap: () {
  // click example
  AdcioAnalytics.onClick(option);

  // Used at the point of screen transition.
  AdcioAnalytics.onPageView(
    path: "Detail/${product.id}",
  );

  // purchase example
  AdcioAnalytics.onPurchase(
    orderId: 'SAMPLE_ORDER_ID',
    productIdOnStore: 'SAMPLE_PRODUCT_ID_ON_STORE',
    amount: product.price.toInt(), // actual purchase price
  );

  // add to cart example
  AdcioAnalytics.onAddToCart(
    cartId: "SAMPLE_CART_ID",
    productIdOnStore: 'SAMPLE_PRODUCT_ID_ON_STORE',
  );
},
```
To learn more about usage of plugin, please visit the [AdcioAnalytics Usage documentation.](https://docs.adcio.ai/en/sdk/log-collection/flutter)

## Issues and feedback
If the plugin has issues, bugs, feedback, Please contact <dev@corca.ai>.