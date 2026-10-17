import '../models/enums.dart';
import '../models/user.dart';

/// An error the UI can show in Bangla.
///
/// Carries a localisation key rather than a sentence so the message follows the
/// user's language, and mirrors the API's error shape (`code`, `message_bn`,
/// `message_en`) so a remote implementation can pass the server's wording
/// straight through without a mapping table.
class ApiException implements Exception {
  const ApiException({
    required this.code,
    this.messageKey,
    this.serverMessageBn,
    this.serverMessageEn,
    this.statusCode,
  });

  /// `validation_error | unauthorized | forbidden | not_found | conflict |
  /// throttled | vendor_not_verified | insufficient_stock | ai_unavailable |
  /// server_error` (API_SPEC "Common codes").
  final String code;

  /// Key into the app's own ARB catalogue, used when the server sent nothing.
  final String? messageKey;

  final String? serverMessageBn;
  final String? serverMessageEn;
  final int? statusCode;

  /// Server text wins when present: the backend is the authority on why it
  /// refused, and it already localises.
  String message(String locale) {
    if (locale == 'bn' && (serverMessageBn?.isNotEmpty ?? false)) {
      return serverMessageBn!;
    }
    if (locale == 'en' && (serverMessageEn?.isNotEmpty ?? false)) {
      return serverMessageEn!;
    }
    if (locale != 'bn' && (serverMessageBn?.isNotEmpty ?? false)) {
      return serverMessageBn!;
    }
    return messageKey ?? 'stateErrorBody';
  }

  @override
  String toString() => 'ApiException($code)';
}

/// Registration payload. Role-specific extras are nullable because only vendors
/// and experts have them (API_SPEC §1).
class RegisterRequest {
  const RegisterRequest({
    required this.name,
    required this.mobile,
    required this.password,
    required this.role,
    required this.district,
    this.shopName,
    this.licenseNo,
    this.specialization,
    this.certification,
  });

  final String name;
  final String mobile;
  final String password;
  final Role role;
  final String district;
  final String? shopName;
  final String? licenseNo;
  final String? specialization;
  final String? certification;
}

abstract interface class AuthRepository {
  Future<AppUser> login({required String mobile, required String password});

  /// Returns the created user. Vendors and experts come back with
  /// `status = pending` and must not reach their shell yet.
  Future<AppUser> register(RegisterRequest request);

  /// FR-3. Always resolves — the response is deliberately generic so the app
  /// cannot be used to discover whether a number is registered.
  Future<void> requestOtp(String mobile);

  Future<void> resetPassword({
    required String mobile,
    required String otp,
    required String newPassword,
  });

  Future<void> logout();

  /// Restores a session from secure storage on cold start, or null.
  Future<AppUser?> restoreSession();
}
