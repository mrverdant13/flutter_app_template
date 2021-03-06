import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_in_method.freezed.dart';

/// A signature for a callback used in the OAuth flow.
///
/// It provides the [authorizationEndpoint] to be visited for the auth process
/// and the [redirectBaseEndpoint] that holds the base URL of the endpoint that
/// is finally returned including OAuth-related query parameters.
typedef OAuthCallback = Future<Uri?> Function({
  required Uri authorizationEndpoint,
  required Uri redirectBaseEndpoint,
});

/// A union of login methods identifiers.
@freezed
class LogInMethod with _$LogInMethod {
  /// An identifier for the OAuth login method.
  const factory LogInMethod.oAuth({
    /// The callback used for the auth process.
    required OAuthCallback callback,
  }) = _LogInMethodOAuth;
}
