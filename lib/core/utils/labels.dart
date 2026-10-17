import '../../l10n/app_localizations.dart';
import '../../data/models/enums.dart';

/// Bangla labels for domain enums.
///
/// Kept apart from the enums themselves so `data/models` stays free of Flutter
/// and l10n imports, and apart from the widgets so two components showing the
/// same status cannot drift into two different words for it.
extension SeverityLabel on Severity {
  String label(AppL10n l) => switch (this) {
        Severity.low => l.severityLow,
        Severity.medium => l.severityMedium,
        Severity.high => l.severityHigh,
        Severity.urgent => l.severityUrgent,
      };
}

extension ConfidenceLabel on ConfidenceLevel {
  String label(AppL10n l) => switch (this) {
        ConfidenceLevel.high => l.diagnosisConfidenceHigh,
        ConfidenceLevel.medium => l.diagnosisConfidenceMedium,
        ConfidenceLevel.low => l.diagnosisConfidenceLow,
      };
}

extension OrderStatusLabel on OrderStatus {
  String label(AppL10n l) => switch (this) {
        OrderStatus.pending => l.orderStatusPending,
        OrderStatus.confirmed => l.orderStatusConfirmed,
        OrderStatus.shipped => l.orderStatusShipped,
        OrderStatus.delivered => l.orderStatusDelivered,
        OrderStatus.rejected => l.orderStatusRejected,
        OrderStatus.cancelled => l.orderStatusCancelled,
      };
}

extension SyncStatusLabel on SyncStatus {
  String label(AppL10n l) => switch (this) {
        SyncStatus.queued => l.syncQueued,
        SyncStatus.uploading => l.syncUploading,
        SyncStatus.synced => l.syncSynced,
        SyncStatus.failed => l.syncFailed,
      };
}

extension NewsCategoryLabel on NewsCategory {
  String label(AppL10n l) => switch (this) {
        NewsCategory.disease => l.newsCategoryDisease,
        NewsCategory.pest => l.newsCategoryPest,
        NewsCategory.virus => l.newsCategoryVirus,
        NewsCategory.nutrientDeficiency => l.newsCategoryNutrient,
      };
}

extension RoleLabel on Role {
  String label(AppL10n l) => switch (this) {
        Role.farmer => l.roleFarmer,
        Role.vendor => l.roleVendor,
        Role.expert => l.roleExpert,
        // Admins are created by seed and never see a public label, but the
        // switch must be total.
        Role.admin => l.navUsers,
      };
}

extension CropLabel on CropType {
  String label(AppL10n l) => switch (this) {
        CropType.rice => l.diagnosisCropRice,
        CropType.potato => l.diagnosisCropPotato,
        CropType.tomato => l.diagnosisCropTomato,
      };
}
