# adcio_analytics

[![pub package](https://img.shields.io/pub/v/adcio_analytics.svg)](https://pub.dev/packages/adcio_analytics)

A Flutter plugin to collect logs for event analysis of ADCIO projects.

adcio_analytics is a app measurement solution that provides statistics on app usage and user engagement.

</br>

## Usage

### Installation

Add `adcio_analytics` as a [dependency in your pubspec.yaml file](https://pub.dev/packages/adcio_analytics/install).

</br>

### Sample Usage

Usually, it's associated with the [adcio_placement](https://pub.dev/packages/adcio_placement) package.

You call `adcioSuggest()` from the [adcio_placement](https://pub.dev/packages/adcio_placement) package and gather the recommended product. With this, you collect three types of logging events: `onClick`, `onImpression`, and `onPurchase`.

</br>

**AdcioImpressionDetector example:**

```dart
class _MyHomePageState extends State<MyHomePage> {
  late Future<AdcioSuggestionRawData> _adcioSuggestion;
  
  @override
  void initState() {
    super.initState();
    _adcioSuggestion = adcioSuggest(
      placementId: '9f9f9b00-dc16-41c7-a5cd-f9a788d3d481',
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _adcioSuggestion,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data as AdcioSuggestionRawData;

            return ListView.builder(
              itemCount: data.suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = data.suggestions[index];
                final product = suggestion.product!;
                final option = AdcioLogOption.fromMap(suggestion.logOptions);

                // wrap the product widget with AdcioImpressionDetector
                return AdcioImpressionDetector(
                  option: option,
                  child: Card(  // product widget
                    child: ListTile(
                      ...
                    ),
                  ),
                );
              },
            );
          } else {
            return ...
          }
        },
      ),
    );
  }
}
```
By wrapping the recommended product Widget as shown below, the `onImpression` event are automatically collected based on actions.

</br>

**onClick example:**
```dart
  final option =
        AdcioLogOption.fromMap(suggestion.logOptions);
  ...
  
  onTap: () {
    ...

    /// adcio onClick example
    AdcioAnalytics.onClick(option);
  },
```

</br>


**onPurchase example:**
```dart
  final option =
        AdcioLogOption.fromMap(suggestion.logOptions);
  ...
  
  onTap: () {
    /// adcio onPurchase example
    AdcioAnalytics.onPurchase(option);
    amount: 23910 // actual purchase price
  },
```
For the `onPurchase` event, you input the actual purchase price that the customer paid into price and call the event when the customer clicks the button at the purchase point.


</br>

## Features

It mainly collects three events: impression, click, and purchase.

Event | Description |  Function
--- | --- | --- | 
impression | 광고 노출 | `AdcioAnalytics.onImpression(option)` 
click | 광고 클릭 | `AdcioAnalytics.onClick(option)` 
purchase | 광고 구매 | `AdcioAnalytics.onPurchase(option, amount: 23910)` 




