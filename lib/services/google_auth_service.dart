import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

const _googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
const _googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
const _driveScopes = <String>['https://www.googleapis.com/auth/drive.appdata'];

String? get _platformClientId {
  if (kIsWeb) {
    return _googleWebClientId.isEmpty ? null : _googleWebClientId;
  }
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return _googleIosClientId.isEmpty ? null : _googleIosClientId;
  }
  return null;
}

/// Indica si la integración Google está lista para la plataforma actual.
/// En Web, el Client ID se inyecta en el build mediante dart-define.
bool get isGoogleAuthConfigured => !kIsWeb || _googleWebClientId.isNotEmpty;

/// Mensaje accionable para una configuración OAuth Web incompleta.
String? get googleAuthConfigurationError {
  if (kIsWeb && _googleWebClientId.isEmpty) {
    return 'OAuth Web no está configurado. El build requiere '
        'GOOGLE_WEB_CLIENT_ID.';
  }
  return null;
}

GoogleSignIn? _googleSignInInstance;

/// Se crea de forma diferida para que Drive siga siendo opcional.
GoogleSignIn get googleSignInInstance => _googleSignInInstance ??= GoogleSignIn(
  // `serverClientId` es para Android; google_sign_in_web no lo soporta.
  serverClientId: kIsWeb || _googleWebClientId.isEmpty
      ? null
      : _googleWebClientId,
  clientId: _platformClientId,
  scopes: _driveScopes,
);

final googleAccountProvider =
    StateNotifierProvider<
      GoogleAccountNotifier,
      AsyncValue<GoogleSignInAccount?>
    >((ref) => GoogleAccountNotifier());

class GoogleAccountNotifier
    extends StateNotifier<AsyncValue<GoogleSignInAccount?>> {
  GoogleAccountNotifier() : super(const AsyncValue.data(null)) {
    lastError = null;
    if (!isGoogleAuthConfigured) {
      _userSubscription = const Stream<GoogleSignInAccount?>.empty().listen(
        (_) {},
      );
      return;
    }

    _userSubscription = googleSignInInstance.onCurrentUserChanged.listen(
      _handleCurrentUserChanged,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Google user stream failed: $error\n$stackTrace');
      },
    );
    state = const AsyncValue.loading();
    _trySilentSignIn();
  }

  late final StreamSubscription<GoogleSignInAccount?> _userSubscription;

  /// Último error técnico de autenticación, visible solo para diagnóstico UI.
  String? lastError;

  Future<void> _handleCurrentUserChanged(GoogleSignInAccount? account) async {
    if (mounted) state = AsyncValue.data(account);

    if (kIsWeb && account != null) {
      try {
        final authorized = await googleSignInInstance.canAccessScopes(
          _driveScopes,
        );
        debugPrint('Google Drive scopes authorized on Web: $authorized');
      } catch (e, st) {
        debugPrint('Google Drive scope check failed on Web: $e\n$st');
      }
    }
  }

  Future<void> _trySilentSignIn() async {
    try {
      final account = await googleSignInInstance.signInSilently();
      if (mounted && account != null) {
        await _handleCurrentUserChanged(account);
      } else if (mounted) {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      debugPrint('Google silent sign-in failed: $e\n$st');
      if (mounted) state = const AsyncValue.data(null);
    }
  }

  Future<bool> signIn() async {
    lastError = null;
    if (!isGoogleAuthConfigured) {
      lastError = googleAuthConfigurationError;
      if (mounted) state = const AsyncValue.data(null);
      return false;
    }

    try {
      final account = await googleSignInInstance.signIn();
      if (account == null) {
        lastError = 'El selector de Google fue cancelado o cerrado.';
        if (mounted) state = const AsyncValue.data(null);
        return false;
      }

      // En Web, el login y el permiso de Drive son operaciones separadas.
      // El segundo paso debe ocurrir dentro de la acción explícita del usuario.
      if (kIsWeb) {
        final hasDriveScope = await googleSignInInstance.canAccessScopes(
          _driveScopes,
        );
        if (!hasDriveScope) {
          final granted = await googleSignInInstance.requestScopes(
            _driveScopes,
          );
          if (!granted) {
            throw StateError(
              'La cuenta no concedió el permiso de Google Drive (drive.appdata).',
            );
          }
        }
      }

      if (mounted) state = AsyncValue.data(account);
      return true;
    } catch (e, st) {
      lastError = e.toString();
      debugPrint('Google sign-in/Drive scope failed: $e\n$st');
      if (mounted) state = const AsyncValue.data(null);
      return false;
    }
  }

  Future<void> signOut() async {
    lastError = null;
    if (!isGoogleAuthConfigured) return;
    await googleSignInInstance.signOut();
    if (mounted) state = const AsyncValue.data(null);
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}
