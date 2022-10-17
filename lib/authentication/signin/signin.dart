import 'package:flutter/material.dart';
import 'package:flutter_social/authentication/signin/button.dart';
import 'package:flutter_social/authentication/signin/email.dart';
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
        SizedBox(height: 24,),
        SignInButton(),
      ],
    );
  }
}
