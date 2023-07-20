# adcio_analytics

A Flutter plugin to collect logs for event analysis of ADCIO projects.

adcio_analytics is a app measurement solution that provides statistics on app usage and user engagement.

</br>

# Installing

You can use the command to add adcio_anlytics as a dependency with the latest stable version:

```console
$ dart pub add adcio_anlytics
```

Or you can manually add adcio_anlytics into the dependencies section in your `pubspec.yaml`:

```yaml
dependencies:
  adcio_anlytics: ^replace-with-latest-version
```

**Import it**  
Now in your Dart code, you can use:
```
import 'package:adcio_analytics/adcio_analytics.dart';
```

</br>

# Usage

To get platform-specific device information as a session ID, your project needs a higher Android SDK version:

### Android Setting

android/app/build.gradle

```
android {
    defaultConfig {
        minSdkVersion 19
    }
}
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
      campaignId: 'campainId',
      productId: 'productId',
    );
AdcioAnalytics.clickLogEvent(option: option);
```
> **Log Option Description**
> - requestId: Advertisement identifier
> - cost: The amount of cost that has been spent by the seller to advertise
> - sessionId: `optional` User device unique value   
(Automatically generate corresponding device identification)
> - memberId: `optional` userId of the your app 
> - campaignId: Campain Id of this Advertisement
> - productId: Product Id
> - price: `optional` The price of the product. This value is needed to calculate the ROAS.

</br>

### set environment variables

When used for testing or flavor settings, an env environment variable file is created and managed.  

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
 > default value 
 >  - env file name: `.env`
 >  - default key: `ROOT_DEV_URL`

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


