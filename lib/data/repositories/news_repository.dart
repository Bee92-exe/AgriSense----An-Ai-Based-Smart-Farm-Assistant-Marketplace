import '../models/enums.dart';
import '../models/news_item.dart';
import '../models/product.dart';

/// Filters the news list exposes. All optional; the server personalises by the
/// farmer's crop preferences and district when they are unset (FR-45).
class NewsQuery {
  const NewsQuery({this.crop, this.category, this.from, this.to});

  final CropType? crop;
  final NewsCategory? category;
  final DateTime? from;
  final DateTime? to;

  NewsQuery copyWith({
    CropType? crop,
    NewsCategory? category,
    DateTime? from,
    DateTime? to,
    bool clearCrop = false,
    bool clearCategory = false,
  }) =>
      NewsQuery(
        crop: clearCrop ? null : (crop ?? this.crop),
        category: clearCategory ? null : (category ?? this.category),
        from: from ?? this.from,
        to: to ?? this.to,
      );
}

abstract interface class NewsRepository {
  Future<List<NewsItem>> list({NewsQuery? query, int page = 1});

  Future<NewsItem> detail(String id);

  /// FR-46: records that the item was delivered and read, for the pilot report.
  Future<void> markRead(String id);

  /// FR-48: the newest 20, kept on device so the list still works offline and
  /// can show "last updated".
  Future<List<NewsItem>> latest({int limit = 20});

  /// FR-49: treatment products for a disease/pest item.
  Future<List<Product>> productsFor(String newsId);
}
