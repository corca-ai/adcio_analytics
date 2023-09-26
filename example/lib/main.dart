import 'package:adcio_core/adcio_core.dart';
import 'package:example/data/mock_product.dart';
import 'package:flutter/material.dart';

import 'package:adcio_analytics/adcio_analytics.dart';

void main() async {
  /// You must call this function before calling the initializeApp function to avoid error.
  WidgetsFlutterBinding.ensureInitialized();

  /// It is really important to use this function of init in AdcioCore at the time of running the app.
  /// To learn more about usage of AdcioCore, please visit the AdcioCore Usage documentation.
  /// https://docs.adcio.ai/en/sdk/core/flutter
  await AdcioCore.initializeApp(clientId: 'SAMPLE_CLIENT_ID');

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
  late Future<List<MockProduct>> _adcioSuggestion;

  @override
  void initState() {
    super.initState();

    /// adcio onPageView example
    /// Currently, this function is called once at the time of page creation.
    /// Be sure to call the function to match the page-changing Navigation!
    AdcioAnalytics.onPageView(
      path: "MainPage",
    );

    /// called adcioSuggest method (adcio_placement package)
    /// ```dart
    /// _adcioSuggestion = adcioSuggest(
    ///   placementId: '9f9f9b00-dc16-41c7-a5cd-f9a788d3d481',
    /// );
    /// ```

    /// mock adcioSuggest() method
    _adcioSuggestion = Future.delayed(const Duration(seconds: 1), () {
      return [
        MockProduct(
          id: '1',
          name: 'Product 1',
          price: 10000,
          image: 'https://picsum.photos/200/300',
          logOptions: {"requestId": "2023081805292275799", "adsetId": "1"},
        ),
        MockProduct(
          id: '2',
          name: 'Product 2',
          price: 12000,
          image: 'https://picsum.photos/200/200',
          logOptions: {"requestId": "2023081805292275799", "adsetId": "2"},
        ),
        MockProduct(
          id: '3',
          name: 'Product 3',
          price: 10300,
          image: 'https://picsum.photos/300/300',
          logOptions: {"requestId": "2023081805292275799", "adsetId": "3"},
        ),
      ];
    });
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
            final data = snapshot.data!;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final product = data[index];
                final option = AdcioLogOption.fromMap(product.logOptions);

                ///
                /// AdcioImpressionDetector example
                /// (This automatically triggers the onImpression logging event)
                return AdcioImpressionDetector(
                  option: option,
                  child: GestureDetector(
                      onTap: () {
                        ///
                        /// adcio onClick example
                        AdcioAnalytics.onClick(
                          option,
                        );

                        /// Call the onPageView function at the point of navigation like this function.
                        AdcioAnalytics.onPageView(
                          path: "Detail/${product.id}",
                        );

                        // navigate to product detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(title: Text(product.name)),
                              body: Center(
                                child: Image.network(
                                  product.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: AnalyticsSampleListTile(product: product)),
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

class AnalyticsSampleListTile extends StatelessWidget {
  const AnalyticsSampleListTile({
    Key? key,
    required this.product,
  }) : super(key: key);

  final MockProduct product;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            product.image,
            width: 100,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                product.name,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text('₩ ${product.price}'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  ///
                  /// adcio onPurchase example
                  AdcioAnalytics.onPurchase(
                    orderId: 'SAMPLE_ORDER_ID',
                    productIdOnStore: 'SAMPLE_PRODUCT_ID_ON_STORE',
                    amount: product.price.toInt(), // actual purchase price
                  );
                },
                icon: const Icon(Icons.shopify_sharp),
                label: const Text('Buy'),
              ),
              TextButton.icon(
                onPressed: () {
                  ///
                  /// adcio onAddToCart example
                  AdcioAnalytics.onAddToCart(
                    cartId: "SAMPLE_CART_ID",
                    productIdOnStore: 'SAMPLE_PRODUCT_ID_ON_STORE',
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Add To Cart'),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
