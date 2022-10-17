import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social/authentication/google_signin/google_signin_button.dart';
import 'package:flutter_social/authentication/signin/button.dart';
import 'package:flutter_social/authentication/signin/controller/signin_controller.dart';
import 'package:flutter_social/authentication/signin/email_field.dart';
import 'package:flutter_social/authentication/signin/forgot_password_button.dart';
import 'package:flutter_social/authentication/signin/or_divider.dart';
import 'package:flutter_social/authentication/signin/password_field.dart';
import 'package:flutter_social/components/loading_error.dart';
import 'package:form_validators/form_validators.dart';

class SignIn extends ConsumerWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SignInState>(signInProvider, (previous, current) {
      if (current.status.isSubmissionInProgress) {
        LoadingSheet.show(context);
      } else if (current.status.isSubmissionFailure) {
        Navigator.of(context).pop();
        ErrorDialog.show(context, "${current.errorMessage}");
      } else if (current.status.isSubmissionSuccess) {
        Navigator.of(context).pop();
      }
    },);
    return Column(
      children: const [
        EmailField(),
        SizedBox(height: 16,),
        PasswordField(),
        ForgotPasswordButton(),
        SizedBox(height: 24,),
        SignInButton(),
        OrDivider(),
        GoogleSignInButton(),
      ],
    );
  }
}
