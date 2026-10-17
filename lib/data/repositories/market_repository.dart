import '../models/enums.dart';
import '../models/product.dart';

/// Search and filter state for Haat_Bazar (FR-17).
class ProductQuery {
  const ProductQuery({
    this.text,
    this.category,
    this.priceMin,
    this.priceMax,
    this.inStockOnly = false,
    this.page = 1,
  });

  final String? text;
  final String? category;
  final int? priceMin;
  final int? priceMax;
  final bool inStockOnly;
  final int page;

  ProductQuery copyWith({
    String? text,
    String? category,
    int? priceMin,
    int? priceMax,
    bool? inStockOnly,
    int? page,
    bool clearCategory = false,
  }) =>
      ProductQuery(
        text: text ?? this.text,
        category: clearCategory ? null : (category ?? this.category),
        priceMin: priceMin ?? this.priceMin,
        priceMax: priceMax ?? this.priceMax,
        inStockOnly: inStockOnly ?? this.inStockOnly,
        page: page ?? this.page,
      );
}

/// A single-vendor order request.
///
/// `totalAmount` is deliberately absent: the API computes totals server-side and
/// a mixed-vendor basket is rejected, so the client must not be able to send a
/// price at all (acceptance criterion T-D3).
class PlaceOrderRequest {
  const PlaceOrderRequest({
    required this.clientUuid,
    required this.items,
    required this.paymentMode,
    required this.placedVia,
    this.note,
  });

  final String clientUuid;
  final List<({String productId, int quantity})> items;
  final String paymentMode; // cod | direct
  final InputMode placedVia;
  final String? note;
}

abstract interface class MarketRepository {
  Future<List<Product>> products({ProductQuery? query});

  Future<Product> product(String id);

  /// Seed, fertiliser, pesticide, fungicide… (server-seeded list).
  Future<List<String>> categories();

  Future<Order> placeOrder(PlaceOrderRequest request);

  Future<List<Order>> orders({OrderStatus? status});

  Future<Order> order(String id);

  /// Only valid while the order is `pending`; the server rejects anything else
  /// with `invalid_transition`.
  Future<Order> cancelOrder(String id);

  Future<Invoice> invoice(String orderId);

  /// FR-26.
  Future<void> rateVendor({
    required String vendorId,
    required int rating,
    String? comment,
  });
}

/// The server-computed invoice. Amounts are integers in taka and are never
/// recalculated on the device.
class Invoice {
  const Invoice({
    required this.orderNo,
    required this.issuedAt,
    required this.items,
    required this.totalAmount,
    required this.vendorShopName,
  });

  final String orderNo;
  final DateTime issuedAt;
  final List<OrderItem> items;
  final int totalAmount;
  final String vendorShopName;

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        orderNo: json['order_no'] as String? ?? '',
        issuedAt: DateTime.tryParse(json['issued_at'] as String? ?? '') ??
            DateTime.now(),
        items: ((json['items'] as List<dynamic>?) ?? const [])
            .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalAmount: (json['total_amount'] as num?)?.toInt() ?? 0,
        vendorShopName: json['vendor_shop_name'] as String? ?? '',
      );
}
