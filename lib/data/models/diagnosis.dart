import 'package:flutter/foundation.dart';

import 'enums.dart';

@immutable
class Disease {
  const Disease({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    this.isHealthy = false,
  });

  final String id;
  final String nameBn;
  final String nameEn;
  final bool isHealthy;

  factory Disease.fromJson(Map<String, dynamic> json) => Disease(
        id: json['id'] as String,
        nameBn: json['name_bn'] as String? ?? '',
        nameEn: json['name_en'] as String? ?? '',
        isHealthy: json['is_healthy'] as bool? ?? false,
      );

  /// Bangla name unless the app is in English and an English name exists.
  String label(String locale) =>
      locale == 'en' && nameEn.isNotEmpty ? nameEn : nameBn;
}

/// One numbered treatment instruction. Each step is separately speakable, which
/// is why the order and the text live together here rather than as a `List<String>`.
@immutable
class TreatmentStep {
  const TreatmentStep({
    required this.order,
    required this.textBn,
    this.textEn,
    this.source,
  });

  final int order;
  final String textBn;
  final String? textEn;

  /// Provenance — BRRI, DAE, BARC… Shown so a farmer can see the advice is not
  /// the model's own invention.
  final String? source;

  factory TreatmentStep.fromJson(Map<String, dynamic> json) => TreatmentStep(
        order: (json['order'] as num?)?.toInt() ?? 0,
        textBn: json['text_bn'] as String? ?? '',
        textEn: json['text_en'] as String?,
        source: json['source'] as String?,
      );

  String label(String locale) =>
      locale == 'en' && (textEn?.isNotEmpty ?? false) ? textEn! : textBn;
}

/// The result of one leaf photo.
///
/// The `showAsFinal` / `disease` / `treatmentSteps` triple is the server's
/// safety decision (confidence < 0.70 ⇒ `disease` is null and nothing is shown
/// as final). The client renders what it is given and additionally refuses to
/// display a low-confidence disease even if a server sent one — belt and braces,
/// because this is the rule that costs a farmer money if it breaks.
@immutable
class Diagnosis {
  const Diagnosis({
    required this.id,
    required this.clientUuid,
    required this.status,
    required this.confidence,
    required this.confidenceLevel,
    required this.createdAt,
    this.imageUrl,
    this.localImagePath,
    this.crop,
    this.disease,
    this.top3 = const [],
    this.treatmentSteps,
    this.showAsFinal = false,
    this.reviewedByExpert = false,
    this.expertNote,
    this.syncStatus = SyncStatus.synced,
  });

  final String id;

  /// Idempotency key (UUIDv4). A re-upload of the same photo must not create a
  /// second diagnosis (FR-27), so this travels with every queued upload.
  final String clientUuid;

  /// `completed | pending_review | expert_reviewed | needs_retake | failed`
  /// (API_SPEC §3). Kept as the wire string: the transitions are the server's.
  final String status;

  final double confidence;
  final ConfidenceLevel confidenceLevel;
  final DateTime createdAt;
  final String? imageUrl;

  /// Set for a photo still sitting in the offline queue, so the list can show
  /// the local thumbnail before the upload has ever succeeded.
  final String? localImagePath;

  final CropType? crop;
  final Disease? disease;
  final List<(Disease, double)> top3;
  final List<TreatmentStep>? treatmentSteps;
  final bool showAsFinal;
  final bool reviewedByExpert;
  final String? expertNote;
  final SyncStatus syncStatus;

  bool get isPendingReview => status == 'pending_review';
  bool get needsRetake => status == 'needs_retake';
  bool get failed => status == 'failed';

  /// The single source of truth for "may I show a disease name?".
  bool get canShowDisease => showAsFinal && disease != null && confidenceLevel.isShowable;

  /// A healthy leaf is not a disease and needs its own wording, not "no result".
  bool get isHealthy => canShowDisease && (disease?.isHealthy ?? false);

  factory Diagnosis.fromJson(Map<String, dynamic> json) => Diagnosis(
        id: json['id'] as String,
        clientUuid: json['client_uuid'] as String? ?? '',
        status: json['status'] as String? ?? 'completed',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
        confidenceLevel: json['confidence_level'] == null
            ? ConfidenceLevel.fromScore(
                (json['confidence'] as num?)?.toDouble() ?? 0)
            : ConfidenceLevel.fromWire(json['confidence_level'] as String?),
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
            DateTime.now(),
        imageUrl: json['image_url'] as String?,
        crop: CropType.fromWire(json['crop'] as String?),
        disease: json['disease'] == null
            ? null
            : Disease.fromJson(json['disease'] as Map<String, dynamic>),
        top3: ((json['top3'] as List<dynamic>?) ?? [])
            .map((e) => e as Map<String, dynamic>)
            .map((m) => (
                  Disease.fromJson({
                    'id': m['disease_id'] ?? '',
                    'name_bn': m['name_bn'] ?? '',
                    'name_en': m['name_en'] ?? '',
                    'is_healthy': false,
                  }),
                  (m['confidence'] as num?)?.toDouble() ?? 0,
                ))
            .toList(),
        treatmentSteps: json['treatment_steps'] == null
            ? null
            : (json['treatment_steps'] as List<dynamic>)
                .map((e) => TreatmentStep.fromJson(e as Map<String, dynamic>))
                .toList(),
        showAsFinal: json['show_as_final'] as bool? ?? false,
        reviewedByExpert: json['reviewed_by_expert'] as bool? ?? false,
        expertNote: json['expert_note'] as String?,
      );

  Diagnosis copyWith({
    String? status,
    SyncStatus? syncStatus,
  }) =>
      Diagnosis(
        id: id,
        clientUuid: clientUuid,
        status: status ?? this.status,
        confidence: confidence,
        confidenceLevel: confidenceLevel,
        createdAt: createdAt,
        imageUrl: imageUrl,
        localImagePath: localImagePath,
        crop: crop,
        disease: disease,
        top3: top3,
        treatmentSteps: treatmentSteps,
        showAsFinal: showAsFinal,
        reviewedByExpert: reviewedByExpert,
        expertNote: expertNote,
        syncStatus: syncStatus ?? this.syncStatus,
      );
}
