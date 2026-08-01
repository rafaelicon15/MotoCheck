import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

const _googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');

final googleSignInInstance = GoogleSignIn(
  clientId: _googleWebClientId.isEmpty ? null : _googleWebClientId,
  scopes: ['https://www.googleapis.com/auth/drive.appdata'],
);

final googleAccountProvider =
    StateNotifierProvider<GoogleAccountNotifier, AsyncValue<GoogleSignInAccount?>>(
        (ref) => GoogleAccountNotifier());

class GoogleAccountNotifier
    extends StateNotifier<AsyncValue<GoogleSignInAccount?>> {
  GoogleAccountNotifier() : super(const AsyncValue.loading()) {
    _trySilentSignIn();
  }

  Future<void> _trySilentSignIn() async {
    try {
      final account = await googleSignInInstance.signInSilently();
      if (mounted) state = AsyncValue.data(account);
    } catch (_) {
      if (mounted) state = const AsyncValue.data(null);
    }
  }

  Future<bool> signIn() async {
    try {
      final account = await googleSignInInstance.signIn();
      if (mounted) state = AsyncValue.data(account);
      return account != null;
    } catch (_) {
      if (mounted) state = const AsyncValue.data(null);
      return false;
    }
  }

  Future<void> signOut() async {
    await googleSignInInstance.signOut();
    if (mounted) state = const AsyncValue.data(null);
  }
}
