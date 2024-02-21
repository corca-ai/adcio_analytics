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

/// impression Widget example
return AdcioImpressionDetector(
  option: option,
  child: YOUR_PRODUCT_WIDGET(
      ...
      onTap: () {

        /// onClick example
        AdcioAnalytics.onClick(
          option: option,
          clientId: "SAMPLE_CLIENT_ID"
        );

        /// onPageView example
        AdcioAnalytics.onPageView(
          path: "Detail/${product.id}",
          clientId: "SAMPLE_CLIENT_ID"
        );

        Navigator.push(context, ... ),
      },
    ),
  );
```

There is a AddToCart example:
```dart
import 'package:adcio_analytics/adcio_analytics.dart';

return YOUR_PRODUCT_CART_WIDGET(
  onTap: () {
    final option = AdcioLogOption.fromMap(suggestion.logOptions);
    
    // onAddToCart example
    AdcioAnalytics.onAddToCart(
      cartId: "SAMPLE_CART_ID",
      productIdOnStore: 'SAMPLE_PRODUCT_ID_ON_STORE',
      clientId: "SAMPLE_CLIENT_ID"
    );
  },
);
```

There is a purchase example:
```dart
import 'package:adcio_analytics/adcio_analytics.dart';

return YOUR_PAYMENT_SUBMIT_WIDGET(
  onTap: () {
    final option = AdcioLogOption.fromMap(suggestion.logOptions);
    
    // onAddToCart example
    AdcioAnalytics.onPurchase(
      orderId: 'SAMPLE_ORDER_ID',
      productIdOnStore: 'SAMPLE_PRODUCT_ID_ON_STORE',
      amount: product.price.toInt(), // actual purchase price
      clientId: "SAMPLE_CLIENT_ID"
    );
  },
);
```
To learn more about usage of plugin, please visit the [AdcioAnalytics Usage documentation.](https://docs.adcio.ai/en/sdk/flutter/log-collection)

## Issues and feedback
If the plugin has issues, bugs, feedback, Please contact <app@corca.ai>.