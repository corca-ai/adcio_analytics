import 'package:adcio_analytics/adcio_analytics.dart';

class AdcioLogOption {
  AdcioLogOption({
    required this.requestId,
    required this.productId,
    required this.campaignId,
    required this.cost,
    String? sessionId,
    this.memberId,
    this.price,
  }) : sessionId = sessionId ?? AdcioAnalytics.sessionId;

  /// Advertisement identifier
  final String requestId;

  /// The amount of the cast that has been spent by the seller to advertise
  final int cost;

  /// device unique id
  ///
  /// Collect for device identification purposes.
  /// Device identifier information is automatically inserted without having to fill in separately.
  final String sessionId;

  /// customerId, userId
  ///
  /// Enter the userId of the your app.
  /// It is used to identify the client's customer.
  final String? memberId;

  /// Campain ID of this advertiment.
  final String campaignId;

  /// Product ID
  final String productId;

  /// The price of the product. This value is needed to calculate the ROAS.
  final int? price;

  factory AdcioLogOption.fromJson(Map json) {
    final cost = json['cost'];
    final price = json['price'];

    return AdcioLogOption(
      requestId: json['requestId'] as String,
      productId: json['productId'] as String,
      campaignId: json['campaignId'] as String,
      cost: (cost is int) ? cost : int.parse(cost as String),
      sessionId: json['sessionId'] as String?,
      memberId: json['memberId'] as String?,
      price: (price is int?) ? price : int.parse(price as String),
    );
  }

  AdcioLogOption copy({
    String? requestId,
    int? cost,
    String? sessionId,
    String? memberId,
    String? campaignId,
    String? productId,
    int? price,
  }) {
    return AdcioLogOption(
      requestId: requestId ?? this.requestId,
      cost: cost ?? this.cost,
      sessionId: sessionId ?? this.sessionId,
      memberId: memberId ?? this.memberId,
      campaignId: campaignId ?? this.campaignId,
      productId: productId ?? this.productId,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> get toJson {
    return {
      'requestId': requestId,
      'cost': cost,
      'sessionId': sessionId,
      'memberId': memberId,
      'campaignId': campaignId,
      'productId': productId,
      'price': price,
    };
  }
}
