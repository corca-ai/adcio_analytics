import 'package:adcio_analytics/adcio_analytics.dart';
import 'package:adcio_analytics/models/log_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///
  /// 1. initialized
  await AdcioAnalytics.init();

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
  int _counter = 0;
  final _option = LogOption(
    requestId: 'requestId',
    cost: 1000,
    sessionId: 'sessionId',
    campaignId: 'campainId',
    productId: 'productId',
  );

  void _incrementCounter() {
    ///
    /// 2. add Click Event
    AdcioAnalytics.clickLogEvent(option: _option);

    _counter++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              AdcioAnalytics.impressionLogEvent(option: _option);
            },
            tooltip: 'impression',
            child: const Icon(CupertinoIcons.eye),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'click',
            child: const Icon(Icons.ads_click),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              AdcioAnalytics.purchaseLogEvent(option: _option);
            },
            tooltip: 'purchase',
            child: const Icon(CupertinoIcons.shopping_cart),
          ),
        ],
      ),
    );
  }
}
