import 'package:flutter/material.dart';
import 'package:flutter_social/authentication/google_signin/google_signin_button.dart';
import 'package:flutter_social/authentication/signin/button.dart';
import 'package:flutter_social/authentication/signin/email.dart';
import 'package:flutter_social/authentication/signin/forgot_password_button.dart';
import 'package:flutter_social/authentication/signin/or_divider.dart';
import 'package:flutter_social/authentication/signin/password.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Email(),
        SizedBox(height: 16,),
        Password(),
        ForgotPasswordButton(),
        SizedBox(height: 24,),
        SignInButton(),
        OrDivider(),
        GoogleSignInButton(),
      ],
    );
  }
}
