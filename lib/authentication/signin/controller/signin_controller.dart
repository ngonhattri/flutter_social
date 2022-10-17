import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validators/form_validators.dart';

part 'signin_state.dart';

final signInProvider = StateNotifierProvider.autoDispose<SignInController, SignInState>(
      (ref) => SignInController(),
);

class SignInController extends StateNotifier<SignInState> {
  SignInController() : super(const SignInState());

  void onEmailChange(String value) {
    final email = Email.dirty(value);
    state = state.copyWith(
      email: email,
      status: Formz.validate([
        email,
        state.password,
      ]),
    );
  }

  void onPasswordChange(String value) {
    final password = Password.dirty(value);
    state = state.copyWith(
      password: password,
      status: Formz.validate([
        state.email,
        password,
      ]),
    );
  }

  void signInWithEmailAndPassword() async {
    if(!state.status.isValidated) return;
    print("signin");
  }
}