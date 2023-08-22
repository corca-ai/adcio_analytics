import 'package:adcio_placement/adcio_placement.dart';
import 'package:flutter/material.dart';

import 'package:adcio_analytics/adcio_analytics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<AdcioSuggestionRawData> _adcioSuggestion;
  @override
  void initState() {
    super.initState();
    _adcioSuggestion = adcioSuggest(
      placementId: '9f9f9b00-dc16-41c7-a5cd-f9a788d3d481',
      baseUrl: 'https://api-dev.adcio.ai', // optional example
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
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

                return Card(
                  ///
                  /// adcio log detector example
                  child: AdcioLogDetector(
                    option: option,
                    child: ListTile(
                      leading: Image.network(
                        product.image,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        product.name,
                        maxLines: 3,
                      ),
                      subtitle: Text('₩ ${product.price}'),
                      trailing: TextButton.icon(
                        onPressed: () {
                          ///
                          /// adcio onPurchase example
                          AdcioAnalytics.onPurchase(
                            option,
                            amount:
                                product.price.toInt(), // actual purchase price
                          );
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Buy'),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
