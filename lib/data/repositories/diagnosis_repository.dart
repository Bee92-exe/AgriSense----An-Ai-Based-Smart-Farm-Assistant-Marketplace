import 'dart:typed_data';

import '../models/diagnosis.dart';
import '../models/enums.dart';
import '../models/product.dart';

/// Two pages are all the farmer history screen asks for by default; the cap
/// matches the API's `page_size` limit of 50.
const int kDiagnosisPageSize = 20;

/// A captured leaf photo on its way to the server.
///
/// The docs' architecture sketch types this as `dart:io`'s `File`, but `dart:io`
/// does not exist on the web target and would drag a platform dependency into
/// the data layer. Bytes plus a filename is the same information, works on every
/// target, and is exactly what a `multipart` upload needs anyway. The capture
/// screen converts an `XFile` into this at the edge.
class PhotoUpload {
  const PhotoUpload({
    required this.bytes,
    required this.filename,
    this.mimeType = 'image/jpeg',
  });

  final Uint8List bytes;
  final String filename;
  final String mimeType;

  int get byteLength => bytes.length;
}

abstract interface class DiagnosisRepository {
  /// Uploads a leaf photo.
  ///
  /// [clientUuid] is mandatory and is the idempotency key: re-sending the same
  /// photo (which the offline queue will do after a timeout) must return the
  /// original diagnosis rather than creating a duplicate (FR-27).
  Future<Diagnosis> submit(
    PhotoUpload photo, {
    required String clientUuid,
    CropType? crop,
  });

  Future<List<Diagnosis>> history({int page = 1});

  Future<Diagnosis> detail(String id);

  /// FR-24: puts a low-confidence case in the expert queue. After this the
  /// diagnosis is `pending_review` and the farmer waits.
  Future<Diagnosis> requestReview(String id);

  /// FR-16: in-stock products from verified vendors, ranked against this
  /// diagnosis' treatment.
  Future<List<Product>> matchedProducts(String diagnosisId);
}
