# adcio_analytics

[![pub package](https://img.shields.io/pub/v/adcio_analytics.svg)](https://pub.dev/packages/adcio_analytics)

A Flutter plugin to collect logs for event analysis of ADCIO projects.

adcio_analytics is a app measurement solution that provides statistics on app usage and user engagement.

</br>

## Usage

### Installation

Add `adcio_analytics` as a [dependency in your pubspec.yaml file](https://pub.dev/packages/adcio_analytics/install).


### Sample Usage

onClick example:
```dart
  ...
  onTap: () {
    ///
    /// adcio onClick example
    final option =
        AdcioLogOption.fromMap(suggestion.logOptions);
    AdcioAnalytics.onClick(option);
  },
```

</br>

## Features

It mainly collects three events: impression, click, and purchase.

Event | Description |  Function
--- | --- | --- | 
impression | 광고 노출 | `AdcioAnalytics.onImpression(option)` 
click | 광고 클릭 | `AdcioAnalytics.onClick(option)` 
purchase | 광고 구매 | `AdcioAnalytics.onPurchase(option, amount: 23910)` 
---




