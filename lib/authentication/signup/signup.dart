import 'package:flutter/material.dart';
import 'package:flutter_social/authentication/signup/button.dart';
import 'package:flutter_social/authentication/signup/email.dart';
import 'package:flutter_social/authentication/signup/name.dart';
import 'package:flutter_social/authentication/signup/password.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Name(),
        SizedBox(
          height: 16,
        ),
        Email(),
        SizedBox(
          height: 16,
        ),
        Password(),
        SizedBox(
          height: 24,
        ),
        SignUpButton(),
      ],
    );
  }
}
