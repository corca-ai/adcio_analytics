# adcio_analytics

A Flutter plugin to collect logs for event analysis of ADCIO projects.

adcio_analytics is a app measurement solution that provides statistics on app usage and user engagement.

</br>

## Getting started

### Add dependency

You can use the command to add adcio_anlytics as a dependency with the latest stable version:

```console
$ dart pub add adcio_anlytics
```

Or you can manually add adcio_anlytics into the dependencies section in your pubspec.yaml:

```yaml
dependencies:
  adcio_anlytics: ^replace-with-latest-version
```
</br>

### Super simple to use

1. initalize in `main.dart`
```dart
void main() async {
  ...
  
  await AdcioAnalytics.init();
}
```

2. call event log in `page.dart`
```dart
final option = LogOption(
      requestId: 'requestId',
      cost: 1000,
      sessionId: 'sessionId',
      campaignId: 'campainId',
      productId: 'productId',
    );
AdcioAnalytics.clickLogEvent(option: option);
```

</br>

### set environment variables

1. create `.env` file in root path

recommend:
```
ROOT_DEV_URL=INPUT_RECEIVER_URL
```

2. update `pubspec.yaml`
```
  assets:
    - .env
```

3. (optional) initalize in `main.dart`
```dart
void main() async {
  ...

  await AdcioAnalytics.init(
    envFileName: 'FILE_NAME',
    urlKey: 'KEY_NAME',
  );
}
```
</br>

## Features

It mainly collects three events: impression, click, and purchase.

Event | Description |  Function
--- | --- | --- | 
impression | 광고 노출 | `AdcioAnalytics.impressionLogEvent(option: option)` 
click | 광고 클릭 | `AdcioAnalytics.clickLogEvent(option: option)` 
purchase | 광고 구매 | `AdcioAnalytics.purchaseLogEvent(option: option)` 


