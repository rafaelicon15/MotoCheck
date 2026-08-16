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

final googleSignInInstance = GoogleSignIn(
  // Android usa el client ID Web como serverClientId para validar el ID token.
  // Web usa ese mismo ID como clientId; iOS recibe su client ID nativo.
  serverClientId: _googleWebClientId.isEmpty ? null : _googleWebClientId,
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
  GoogleAccountNotifier() : super(const AsyncValue.loading()) {
    _userSubscription = googleSignInInstance.onCurrentUserChanged.listen(
      _handleCurrentUserChanged,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Google user stream failed: $error\n$stackTrace');
      },
    );
    _trySilentSignIn();
  }

  late final StreamSubscription<GoogleSignInAccount?> _userSubscription;

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
    try {
      final account = await googleSignInInstance.signIn();
      if (mounted) state = AsyncValue.data(account);
      return account != null;
    } catch (e, st) {
      debugPrint('Google sign-in failed: $e\n$st');
      if (mounted) state = const AsyncValue.data(null);
      return false;
    }
  }

  Future<void> signOut() async {
    await googleSignInInstance.signOut();
    if (mounted) state = const AsyncValue.data(null);
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}
