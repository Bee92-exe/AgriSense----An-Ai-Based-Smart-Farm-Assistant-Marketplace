import 'package:flutter/foundation.dart';

import 'enums.dart';

/// Provenance for a news item. The SRS data dictionary calls for the source to
/// be recorded on every published item, and the UI must show it.
@immutable
class NewsSource {
  const NewsSource({required this.name, this.url});

  final String name;
  final String? url;

  factory NewsSource.fromJson(Map<String, dynamic> json) => NewsSource(
        name: json['name'] as String? ?? '',
        url: json['url'] as String?,
      );
}

/// One Krishi Barta item as a farmer sees it.
///
/// Only ever constructed from an approved item — `GET /news` is specified to
/// return published items only, and unapproved drafts must never reach a farmer
/// (acceptance criterion + test T-S7).
@immutable
class NewsItem {
  const NewsItem({
    required this.id,
    required this.titleBn,
    required this.summaryBn,
    required this.category,
    required this.crop,
    required this.severity,
    required this.publishedAt,
    required this.source,
    this.titleEn,
    this.summaryEn,
    this.symptomsBn,
    this.advisedActionBn,
    this.affectedDistricts = const [],
    this.verifiedBy,
    this.imageUrls = const [],
    this.isUrgent = false,
    this.isRead = false,
  });

  final String id;
  final String titleBn;
  final String? titleEn;
  final String summaryBn;
  final String? summaryEn;
  final String? symptomsBn;
  final String? advisedActionBn;
  final NewsCategory category;
  final CropType? crop;
  final Severity severity;
  final List<String> affectedDistricts;
  final NewsSource source;
  final String? verifiedBy;
  final DateTime publishedAt;
  final List<String> imageUrls;
  final bool isUrgent;
  final bool isRead;

  String title(String locale) =>
      locale == 'en' && (titleEn?.isNotEmpty ?? false) ? titleEn! : titleBn;

  String summary(String locale) =>
      locale == 'en' && (summaryEn?.isNotEmpty ?? false) ? summaryEn! : summaryBn;

  factory NewsItem.fromJson(Map<String, dynamic> json) => NewsItem(
        id: json['id'] as String,
        titleBn: json['title_bn'] as String? ?? '',
        titleEn: json['title_en'] as String?,
        summaryBn: json['summary_bn'] as String? ?? '',
        summaryEn: json['summary_en'] as String?,
        symptomsBn: json['symptoms_bn'] as String?,
        advisedActionBn: json['advised_action_bn'] as String?,
        category: NewsCategory.fromWire(json['category'] as String?),
        crop: CropType.fromWire(json['crop'] as String?),
        severity: Severity.fromWire(json['severity'] as String?),
        affectedDistricts:
            ((json['affected_districts'] as List<dynamic>?) ?? const [])
                .map((e) => e.toString())
                .toList(),
        source: NewsSource.fromJson(
          (json['source'] as Map<String, dynamic>?) ?? const {'name': ''},
        ),
        verifiedBy: json['verified_by'] as String?,
        publishedAt:
            DateTime.tryParse(json['published_at'] as String? ?? '') ??
                DateTime.now(),
        imageUrls: ((json['images'] as List<dynamic>?) ?? const [])
            .map((e) => e.toString())
            .toList(),
        isUrgent: json['is_urgent'] as bool? ?? false,
        isRead: json['read'] as bool? ?? false,
      );

  NewsItem copyWith({bool? isRead}) => NewsItem(
        id: id,
        titleBn: titleBn,
        titleEn: titleEn,
        summaryBn: summaryBn,
        summaryEn: summaryEn,
        symptomsBn: symptomsBn,
        advisedActionBn: advisedActionBn,
        category: category,
        crop: crop,
        severity: severity,
        affectedDistricts: affectedDistricts,
        source: source,
        verifiedBy: verifiedBy,
        publishedAt: publishedAt,
        imageUrls: imageUrls,
        isUrgent: isUrgent,
        isRead: isRead ?? this.isRead,
      );
}
