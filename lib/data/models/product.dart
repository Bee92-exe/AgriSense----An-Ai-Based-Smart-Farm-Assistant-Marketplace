import 'package:flutter/foundation.dart';

import 'enums.dart';

/// The public face of a seller. A farmer never sees a vendor's contact details
/// until they place an order with them (doc 04, "Vendors get buyer contact info
/// only for their own orders" — and the reverse).
@immutable
class VendorSummary {
  const VendorSummary({
    required this.id,
    required this.shopName,
    required this.verified,
    this.rating,
  });

  final String id;
  final String shopName;
  final bool verified;
  final double? rating;

  factory VendorSummary.fromJson(Map<String, dynamic> json) => VendorSummary(
        id: json['id'] as String? ?? '',
        shopName: json['shop_name'] as String? ?? '',
        verified: json['verified'] as bool? ?? false,
        rating: (json['rating'] as num?)?.toDouble(),
      );
}

/// A listing in Haat_Bazar.
///
/// `price` and `stock` are integers straight from the server. Nothing about
/// price, stock or availability is computed on the device — the docs are explicit
/// that the server is the authority, so this class only ever carries values
/// through.
@immutable
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.inStock,
    required this.vendor,
    this.nameBn,
    this.description,
    this.imageUrl,
    this.activeIngredient,
    this.targetDiseases = const [],
    this.matchScore,
    this.matchReasonBn,
  });

  final String id;
  final String name;
  final String? nameBn;

  /// `seed | fertilizer | pesticide | fungicide | …`
  final String category;

  /// Integer taka.
  final int price;

  final int stock;
  final bool inStock;
  final String? description;
  final String? imageUrl;
  final String? activeIngredient;
  final List<String> targetDiseases;
  final VendorSummary vendor;

  /// Present only on the "matched products" response for a diagnosis (FR-16).
  final double? matchScore;
  final String? matchReasonBn;

  String label(String locale) =>
      locale == 'bn' && (nameBn?.isNotEmpty ?? false) ? nameBn! : name;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        nameBn: json['name_bn'] as String?,
        category: json['category'] as String? ?? '',
        price: (json['price'] as num?)?.toInt() ?? 0,
        stock: (json['stock'] as num?)?.toInt() ?? 0,
        inStock: json['in_stock'] as bool? ?? ((json['stock'] as num?)?.toInt() ?? 0) > 0,
        description: json['description'] as String?,
        imageUrl: json['image_url'] as String?,
        activeIngredient: json['active_ingredient'] as String?,
        targetDiseases: ((json['target_diseases'] as List<dynamic>?) ?? const [])
            .map((e) => e.toString())
            .toList(),
        vendor: VendorSummary.fromJson(
          (json['vendor'] as Map<String, dynamic>?) ?? const {'shop_name': ''},
        ),
        matchScore: (json['match_score'] as num?)?.toDouble(),
        matchReasonBn: json['match_reason_bn'] as String?,
      );
}

/// One line of an order, with the prices the *server* decided.
@immutable
class OrderItem {
  const OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  final String productId;
  final String name;
  final int quantity;
  final int unitPrice;
  final int subtotal;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: json['product_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
        unitPrice: (json['unit_price'] as num?)?.toInt() ?? 0,
        subtotal: (json['subtotal'] as num?)?.toInt() ?? 0,
      );
}

@immutable
class OrderStatusEvent {
  const OrderStatusEvent({required this.status, required this.at});

  final OrderStatus status;
  final DateTime at;

  factory OrderStatusEvent.fromJson(Map<String, dynamic> json) =>
      OrderStatusEvent(
        status: OrderStatus.fromWire(json['status'] as String?),
        at: DateTime.tryParse(json['at'] as String? ?? '') ?? DateTime.now(),
      );
}

@immutable
class Order {
  const Order({
    required this.id,
    required this.orderNo,
    required this.status,
    required this.displayStatus,
    required this.paymentMode,
    required this.placedVia,
    required this.totalAmount,
    required this.items,
    required this.vendor,
    required this.createdAt,
    this.history = const [],
  });

  final String id;
  final String orderNo;
  final OrderStatus status;

  /// What the farmer is shown. Per decision A4 the server may fold `confirmed`
  /// into `pending` here rather than the client guessing.
  final OrderStatus displayStatus;

  final String paymentMode;
  final InputMode placedVia;
  final int totalAmount;
  final List<OrderItem> items;
  final VendorSummary vendor;
  final List<OrderStatusEvent> history;
  final DateTime createdAt;

  /// Cancelling is only possible before the vendor accepts (API_SPEC §7).
  bool get canCancel => status == OrderStatus.pending;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String,
        orderNo: json['order_no'] as String? ?? '',
        status: OrderStatus.fromWire(json['status'] as String?),
        displayStatus: OrderStatus.fromWire(
          (json['display_status'] ?? json['status']) as String?,
        ),
        paymentMode: json['payment_mode'] as String? ?? 'cod',
        placedVia: json['placed_via'] == 'voice'
            ? InputMode.voice
            : InputMode.touch,
        totalAmount: (json['total_amount'] as num?)?.toInt() ?? 0,
        items: ((json['items'] as List<dynamic>?) ?? const [])
            .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        vendor: VendorSummary.fromJson(
          (json['vendor'] as Map<String, dynamic>?) ?? const {'shop_name': ''},
        ),
        history: ((json['history'] as List<dynamic>?) ?? const [])
            .map((e) => OrderStatusEvent.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
            DateTime.now(),
      );
}
