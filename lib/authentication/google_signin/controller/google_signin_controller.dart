import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social/repository/auth_repo_provider.dart';
import 'package:authentication_repository/authentication_repository.dart';

import '../../controller/authentication_controller.dart';

final googleSignInProvider =
    StateNotifierProvider<GoogleSignInController, GoogleSignInState>(
  (ref) {
    final authenticationRepository = ref.watch(authRepoProvider);
    return GoogleSignInController(authenticationRepository);
  },
);

enum GoogleSignInState {
  initial,
  loading,
  success,
  error,
}

class GoogleSignInController extends StateNotifier<GoogleSignInState> {
  final AuthenticationRepository _authenticationRepository;

  GoogleSignInController(this._authenticationRepository)
      : super(GoogleSignInState.initial);

  Future<void> signInWithGoogle() async {
    state = GoogleSignInState.loading;
    try {
      final isNewUser = await _authenticationRepository.signInWithGoogle();
      final authUser = await _authenticationRepository.user.first;
      if (isNewUser != null && isNewUser) {
        FirebaseFirestore.instance.collection('users').doc(authUser.id).set(
          {
            'name': authUser.name,
            'email': authUser.email,
            'profilePicture': authUser.profilePicture,
            'bio': '',
            'coverImage': '',
          },
        );
      }

      state = GoogleSignInState.success;
    } on SignInWithGoogleFailure catch (_) {
      state = GoogleSignInState.error;
    }
  }
}
