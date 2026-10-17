import 'dart:math';

import '../models/diagnosis.dart';
import '../models/enums.dart';
import '../models/news_item.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/weather.dart';
import '../repositories/auth_repository.dart';
import '../repositories/diagnosis_repository.dart';
import '../repositories/market_repository.dart';
import '../repositories/news_repository.dart';
import '../repositories/weather_repository.dart';
import 'mock_seed.dart';

/// Switches that make the mock behave like a real, occasionally-flaky server.
///
/// The design system asks for delays and random failures "so error states get
/// built" — an error path that has never been rendered is not an error path that
/// works. [failRate] defaults to 0 so normal use is not frustrating; the debug
/// menu raises it.
class MockConfig {
  MockConfig({this.failRate = 0});

  /// 0.0-1.0 chance that any single call throws.
  double failRate;

  static const Duration minLatency = Duration(milliseconds: 300);
  static const Duration maxLatency = Duration(milliseconds: 1500);
}

final _random = Random();

Future<void> _lag() => Future<void>.delayed(
      Duration(
        milliseconds: MockConfig.minLatency.inMilliseconds +
            _random.nextInt(
              MockConfig.maxLatency.inMilliseconds -
                  MockConfig.minLatency.inMilliseconds,
            ),
      ),
    );

/// Throws when the injected failure rate says so.
///
/// Uses the same [ApiException] shape a real failure would, so an error state
/// built against the mock is exercising the real code path.
Future<void> _maybeFail(MockConfig config) async {
  await _lag();
  if (config.failRate > 0 && _random.nextDouble() < config.failRate) {
    throw const ApiException(
      code: 'server_error',
      messageKey: 'stateErrorBody',
      statusCode: 500,
    );
  }
}

String _nowIso() => DateTime.now().toIso8601String();

/// Demo accounts. Documented in the handoff so the UI can be driven without
/// guessing, and deliberately not a "log in with anything" mock — the failure
/// path matters more than convenience.
const Map<String, Map<String, dynamic>> kDemoAccounts = {
  '01711000001': {
    'password': 'agrisense',
    'name': 'আব্দুল করিম',
    'role': 'farmer',
    'district': 'ঢাকা',
    'farm_size': 2.5,
    'crop_preferences': ['rice', 'potato'],
  },
  '01711000002': {
    'password': 'agrisense',
    'name': 'রহিম মিয়া',
    'role': 'vendor',
    'district': 'গাজীপুর',
    'shop_name': 'রহিম কৃষি ভান্ডার',
    'verification_status': 'verified',
  },
  '01711000003': {
    'password': 'agrisense',
    'name': 'ড. মাহবুবুর রহমান',
    'role': 'expert',
    'district': 'ঢাকা',
    'specialization': 'ধান ও সবজির রোগ',
    'certification': 'BARI-2019-4471',
  },
};

Map<String, dynamic> _userJson(String mobile, Map<String, dynamic> a) {
  final role = a['role'] as String;
  return {
    'id': 'usr-${mobile.substring(mobile.length - 4)}',
    'name': a['name'],
    'mobile': mobile,
    'role': role,
    'status': 'active',
    'district': a['district'],
    'farm_size': a['farm_size'],
    'crop_preferences': a['crop_preferences'] ?? <String>[],
    'language': 'bn',
    'high_contrast': false,
    'voice_mode': true,
    if (role == 'vendor')
      'vendor': {
        'shop_name': a['shop_name'],
        'verification_status': a['verification_status'],
        'rating': 4.6,
      },
    if (role == 'expert')
      'expert': {
        'specialization': a['specialization'],
        'certification': a['certification'],
      },
  };
}

class MockAuthRepository implements AuthRepository {
  MockAuthRepository({MockConfig? config}) : _config = config ?? MockConfig();

  final MockConfig _config;

  /// Accounts created through the register screen during this session, so a new
  /// registration can immediately log in.
  final Map<String, Map<String, dynamic>> _registered = {};

  @override
  Future<AppUser> login({
    required String mobile,
    required String password,
  }) async {
    await _maybeFail(_config);
    final match = kDemoAccounts[mobile] ?? _registered[mobile];
    if (match == null || match['password'] != password) {
      throw const ApiException(
        code: 'unauthorized',
        messageKey: 'loginFailed',
        statusCode: 401,
      );
    }
    return AppUser.fromJson(_userJson(mobile, match));
  }

  @override
  Future<AppUser> register(RegisterRequest request) async {
    await _maybeFail(_config);
    if (kDemoAccounts.containsKey(request.mobile) ||
        _registered.containsKey(request.mobile)) {
      throw const ApiException(
        code: 'conflict',
        messageKey: 'phone_registered',
        statusCode: 409,
      );
    }
    final store = <String, dynamic>{
      'password': request.password,
      'name': request.name,
      'role': request.role.wire,
      'district': request.district,
      if (request.shopName != null) 'shop_name': request.shopName,
      if (request.shopName != null) 'verification_status': 'pending',
      if (request.specialization != null)
        'specialization': request.specialization,
      if (request.certification != null)
        'certification': request.certification,
    };
    _registered[request.mobile] = store;

    // A7: vendors and experts register as `pending` and cannot use their shell
    // until an admin approves them.
    final needsApproval =
        request.role == Role.vendor || request.role == Role.expert;
    return AppUser(
      id: 'usr-new',
      name: request.name,
      mobile: request.mobile,
      role: request.role,
      status: needsApproval ? AccountStatus.pending : AccountStatus.active,
      district: request.district,
      vendor: request.role == Role.vendor
          ? VendorProfile(
              shopName: request.shopName ?? '',
              verificationStatus: 'pending',
            )
          : null,
      expert: request.role == Role.expert
          ? ExpertProfile(
              specialization: request.specialization,
              certification: request.certification,
            )
          : null,
    );
  }

  @override
  Future<void> requestOtp(String mobile) async {
    // Deliberately always succeeds: API_SPEC says the response must not reveal
    // whether a number exists.
    await _maybeFail(_config);
  }

  @override
  Future<void> resetPassword({
    required String mobile,
    required String otp,
    required String newPassword,
  }) async {
    await _maybeFail(_config);
    if (otp != '123456') {
      throw const ApiException(code: 'validation_error', messageKey: 'otpInvalid');
    }
    final account = kDemoAccounts[mobile] ?? _registered[mobile];
    if (account != null) account['password'] = newPassword;
  }

  @override
  Future<void> logout() async {
    await _lag();
  }

  @override
  Future<AppUser?> restoreSession() async => null;
}

class MockDiagnosisRepository implements DiagnosisRepository {
  MockDiagnosisRepository({MockConfig? config})
      : _config = config ?? MockConfig(),
        _history = diagnosisSeed(_nowIso()).map(Diagnosis.fromJson).toList();

  final MockConfig _config;
  final List<Diagnosis> _history;

  /// Photos captured offline. Surfaced in history with a sync chip so the queue
  /// is visible before the upload layer exists (FR-27).
  final List<Diagnosis> _queued = [];

  /// Picks the canned outcome for a crop so all three confidence bands are
  /// reachable from the UI: rice → high, potato → medium, tomato → low.
  Diagnosis _resultFor(CropType? crop, String clientUuid) {
    final template = switch (crop) {
      CropType.rice => diagnosisSeed(_nowIso())[0],
      CropType.potato => diagnosisSeed(_nowIso())[1],
      CropType.tomato => diagnosisSeed(_nowIso())[2],
      null => diagnosisSeed(_nowIso())[_random.nextInt(3)],
    };
    return Diagnosis.fromJson({
      ...template,
      'id': 'dx-${DateTime.now().microsecondsSinceEpoch}',
      'client_uuid': clientUuid,
      'created_at': _nowIso(),
    });
  }

  @override
  Future<Diagnosis> submit(
    PhotoUpload photo, {
    required String clientUuid,
    CropType? crop,
  }) async {
    await _maybeFail(_config);
    final result = _resultFor(crop ?? CropType.rice, clientUuid);
    _history.insert(0, result);
    return result;
  }

  @override
  Future<List<Diagnosis>> history({int page = 1}) async {
    await _maybeFail(_config);
    if (page > 1) return const [];
    return [..._queued, ..._history];
  }

  @override
  Future<Diagnosis> detail(String id) async {
    await _maybeFail(_config);
    for (final d in [..._queued, ..._history]) {
      if (d.id == id) return d;
    }
    throw const ApiException(code: 'not_found', messageKey: 'stateErrorBody');
  }

  @override
  Future<Diagnosis> requestReview(String id) async {
    await _maybeFail(_config);
    final index = _history.indexWhere((d) => d.id == id);
    if (index == -1) {
      throw const ApiException(code: 'not_found', messageKey: 'stateErrorBody');
    }
    final updated = _history[index].copyWith(status: 'pending_review');
    _history[index] = updated;
    return updated;
  }

  @override
  Future<List<Product>> matchedProducts(String diagnosisId) async {
    await _maybeFail(_config);
    final diagnosis = await detail(diagnosisId);
    final diseaseId = diagnosis.disease?.id;
    final productIds = diseaseId == null
        ? <String>[]
        : (kDiseaseProductMap[diseaseId] ?? <String>[]);

    final market = MockMarketRepository(config: _config);
    final all = await market.products();
    return all
        .where((p) => productIds.contains(p.id))
        .map(
          (p) => Product.fromJson({
            'id': p.id,
            'name': p.name,
            'name_bn': p.nameBn,
            'category': p.category,
            'price': p.price,
            'stock': p.stock,
            'in_stock': p.inStock,
            'description': p.description,
            'active_ingredient': p.activeIngredient,
            'target_diseases': p.targetDiseases,
            'vendor': {
              'id': p.vendor.id,
              'shop_name': p.vendor.shopName,
              'verified': p.vendor.verified,
              'rating': p.vendor.rating,
            },
            'match_score': 0.9,
            'match_reason_bn': 'এই রোগের চিকিৎসায় ব্যবহৃত',
          }),
        )
        .toList();
  }

  /// Adds a photo that could not be uploaded. Called by the offline queue.
  Diagnosis enqueueOffline(PhotoUpload photo, String clientUuid, CropType? crop) {
    final pending = Diagnosis(
      id: 'dx-queued-${DateTime.now().microsecondsSinceEpoch}',
      clientUuid: clientUuid,
      status: 'pending_review',
      confidence: 0,
      confidenceLevel: ConfidenceLevel.low,
      createdAt: DateTime.now(),
      crop: crop,
      syncStatus: SyncStatus.queued,
    );
    _queued.insert(0, pending);
    return pending;
  }
}

class MockMarketRepository implements MarketRepository {
  MockMarketRepository({MockConfig? config})
      : _config = config ?? MockConfig(),
        _orders = orderSeed(_nowIso()).map(Order.fromJson).toList();

  final MockConfig _config;
  final List<Order> _orders;

  bool _isVerifiedVendor(String vendorId) {
    final vendor = kVendorSeed.firstWhere(
      (v) => v['id'] == vendorId,
      orElse: () => const {'verification_status': 'pending'},
    );
    return vendor['verification_status'] == 'verified';
  }

  List<Product> get _catalogue => kProductSeed
      // FR-22/acceptance: only verified vendors' products may be listed, and
      // the filter lives here rather than in the UI so no screen can bypass it.
      .where((p) => _isVerifiedVendor(p['vendor_id'] as String))
      .map(
        (p) => Product.fromJson({
          ...p,
          'in_stock': (p['stock'] as num) > 0,
          'vendor': {
            'id': p['vendor_id'],
            'shop_name': kVendorSeed.firstWhere(
              (v) => v['id'] == p['vendor_id'],
            )['shop_name'],
            'verified': true,
            'rating': kVendorSeed.firstWhere(
              (v) => v['id'] == p['vendor_id'],
            )['rating'],
          },
        }),
      )
      .toList();

  @override
  Future<List<Product>> products({ProductQuery? query}) async {
    await _maybeFail(_config);
    final q = query ?? const ProductQuery();
    var items = _catalogue;

    if (q.text != null && q.text!.trim().isNotEmpty) {
      final needle = q.text!.trim().toLowerCase();
      items = items
          .where((p) =>
              p.name.toLowerCase().contains(needle) ||
              (p.nameBn ?? '').contains(q.text!.trim()) ||
              (p.activeIngredient ?? '').toLowerCase().contains(needle))
          .toList();
    }
    if (q.category != null) {
      items = items.where((p) => p.category == q.category).toList();
    }
    if (q.priceMin != null) {
      items = items.where((p) => p.price >= q.priceMin!).toList();
    }
    if (q.priceMax != null) {
      items = items.where((p) => p.price <= q.priceMax!).toList();
    }
    if (q.inStockOnly) {
      items = items.where((p) => p.inStock).toList();
    }
    return items;
  }

  @override
  Future<Product> product(String id) async {
    await _maybeFail(_config);
    final found = _catalogue.where((p) => p.id == id);
    if (found.isEmpty) {
      throw const ApiException(code: 'not_found', messageKey: 'no_products_found');
    }
    return found.first;
  }

  @override
  Future<List<String>> categories() async {
    await _lag();
    return ['seed', 'fertilizer', 'pesticide', 'fungicide', 'equipment'];
  }

  @override
  Future<Order> placeOrder(PlaceOrderRequest request) async {
    await _maybeFail(_config);

    // One vendor per order (API_SPEC §7): mixing vendors is a client bug, so it
    // fails loudly here the same way the server would with a 400.
    final products = <Product>[];
    for (final item in request.items) {
      products.add(await product(item.productId));
    }
    final vendorIds = products.map((p) => p.vendor.id).toSet();
    if (vendorIds.length > 1) {
      throw const ApiException(
        code: 'validation_error',
        messageKey: 'one_vendor_per_order',
        statusCode: 400,
      );
    }

    final items = <OrderItem>[
      for (var i = 0; i < products.length; i++)
        OrderItem(
          productId: products[i].id,
          name: products[i].label('bn'),
          quantity: request.items[i].quantity,
          unitPrice: products[i].price,
          subtotal: products[i].price * request.items[i].quantity,
        ),
    ];

    final order = Order(
      id: 'ord-${DateTime.now().microsecondsSinceEpoch}',
      orderNo: 'AS-2026-${(900000 + _orders.length).toString()}',
      status: OrderStatus.pending,
      displayStatus: OrderStatus.pending,
      paymentMode: request.paymentMode,
      placedVia: request.placedVia,
      totalAmount: items.fold<int>(0, (sum, i) => sum + i.subtotal),
      items: items,
      vendor: products.first.vendor,
      history: [
        OrderStatusEvent(status: OrderStatus.pending, at: DateTime.now()),
      ],
      createdAt: DateTime.now(),
    );
    _orders.insert(0, order);
    return order;
  }

  @override
  Future<List<Order>> orders({OrderStatus? status}) async {
    await _maybeFail(_config);
    if (status == null) return List.unmodifiable(_orders);
    return _orders.where((o) => o.status == status).toList();
  }

  @override
  Future<Order> order(String id) async {
    await _maybeFail(_config);
    final found = _orders.where((o) => o.id == id);
    if (found.isEmpty) {
      throw const ApiException(code: 'not_found', messageKey: 'stateErrorBody');
    }
    return found.first;
  }

  @override
  Future<Order> cancelOrder(String id) async {
    await _maybeFail(_config);
    final index = _orders.indexWhere((o) => o.id == id);
    if (index == -1) {
      throw const ApiException(code: 'not_found', messageKey: 'stateErrorBody');
    }
    if (!_orders[index].canCancel) {
      throw const ApiException(
        code: 'invalid_transition',
        messageKey: 'order_cannot_cancel',
        statusCode: 409,
      );
    }
    final original = _orders[index];
    final cancelled = Order(
      id: original.id,
      orderNo: original.orderNo,
      status: OrderStatus.cancelled,
      displayStatus: OrderStatus.cancelled,
      paymentMode: original.paymentMode,
      placedVia: original.placedVia,
      totalAmount: original.totalAmount,
      items: original.items,
      vendor: original.vendor,
      history: [
        ...original.history,
        OrderStatusEvent(status: OrderStatus.cancelled, at: DateTime.now()),
      ],
      createdAt: original.createdAt,
    );
    _orders[index] = cancelled;
    return cancelled;
  }

  @override
  Future<Invoice> invoice(String orderId) async {
    final o = await order(orderId);
    return Invoice(
      orderNo: o.orderNo,
      issuedAt: o.createdAt,
      items: o.items,
      totalAmount: o.totalAmount,
      vendorShopName: o.vendor.shopName,
    );
  }

  @override
  Future<void> rateVendor({
    required String vendorId,
    required int rating,
    String? comment,
  }) async {
    await _maybeFail(_config);
  }
}

class MockNewsRepository implements NewsRepository {
  MockNewsRepository({MockConfig? config}) : _config = config ?? MockConfig();

  final MockConfig _config;
  final Map<String, bool> _readState = {};
  List<NewsItem>? _cache;

  List<NewsItem> get _items => _cache ??= newsSeed(_nowIso())
      .map(NewsItem.fromJson)
      .map((n) => n.copyWith(isRead: _readState[n.id] ?? n.isRead))
      .toList();

  @override
  Future<List<NewsItem>> list({NewsQuery? query, int page = 1}) async {
    await _maybeFail(_config);
    if (page > 1) return const [];
    final q = query ?? const NewsQuery();
    var items = _items;
    if (q.crop != null) {
      items = items.where((n) => n.crop == q.crop).toList();
    }
    if (q.category != null) {
      items = items.where((n) => n.category == q.category).toList();
    }
    // Urgent first, then newest — the ordering the design system implies by
    // putting the urgent banner above everything else.
    items = [...items]..sort((a, b) {
        if (a.isUrgent != b.isUrgent) return a.isUrgent ? -1 : 1;
        return b.publishedAt.compareTo(a.publishedAt);
      });
    return items;
  }

  @override
  Future<NewsItem> detail(String id) async {
    await _maybeFail(_config);
    final found = _items.where((n) => n.id == id);
    if (found.isEmpty) {
      throw const ApiException(code: 'not_found', messageKey: 'stateErrorBody');
    }
    return found.first;
  }

  @override
  Future<void> markRead(String id) async {
    _readState[id] = true;
    _cache = null;
    await _lag();
  }

  @override
  Future<List<NewsItem>> latest({int limit = 20}) async {
    final all = await list();
    return all.take(limit).toList();
  }

  @override
  Future<List<Product>> productsFor(String newsId) async {
    final item = await detail(newsId);
    final market = MockMarketRepository(config: _config);
    final all = await market.products();
    if (item.category == NewsCategory.disease ||
        item.category == NewsCategory.virus) {
      return all.where((p) => p.targetDiseases.isNotEmpty).toList();
    }
    // Pest and nutrient items match on category rather than disease.
    return all
        .where((p) => p.category == 'pesticide' || p.category == 'fertilizer')
        .toList();
  }
}

class MockWeatherRepository implements WeatherRepository {
  MockWeatherRepository({MockConfig? config, String? district})
      : _config = config ?? MockConfig(),
        _district = district ?? 'ঢাকা';

  final MockConfig _config;
  String _district;

  @override
  Future<WeatherReport> report({String? district}) async {
    await _maybeFail(_config);
    if (district != null && district.isNotEmpty) _district = district;
    return WeatherReport.fromJson(weatherSeed(_nowIso(), _district));
  }

  @override
  Future<List<WeatherAlert>> activeAlerts({String? district}) async {
    final report = await this.report(district: district);
    return report.alerts;
  }
}
