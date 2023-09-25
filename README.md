#  adcio_analytics
[![pub package](https://img.shields.io/pub/v/adcio_analytics.svg)](https://pub.dev/packages/adcio_analytics)

Flutter plugin that collects logs for event analysis of ADCIO projects.

To learn more about ADCIO, please visit the [ADCIO website](https://www.adcio.ai/)

## Getting Started
To get started with ADCIO account, please register [ADCIO account](https://app.adcio.ai/en/)

## Usage
This is a simple example of using the onClick function:
```dart
import 'package:adcio_analytics/adcio_analytics.dart';

final option = AdcioLogOption.fromMap(suggestion.logOptions);

onTap: () {
  AdcioAnalytics.onClick(option);
},
```
To learn more about usage of plugin, please visit the [AdcioAnalytics Usage documentation.](https://docs.adcio.ai/en/sdk/log-collection/flutter)

## Issues and feedback
If the plugin has issues, bugs, feedback, Please contact <dev@corca.ai>.