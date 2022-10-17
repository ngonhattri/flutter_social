import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social/authentication/signup/button.dart';
import 'package:flutter_social/authentication/signup/controller/signup_controller.dart';
import 'package:flutter_social/authentication/signup/email_field.dart';
import 'package:flutter_social/authentication/signup/name_field.dart';
import 'package:flutter_social/authentication/signup/password_field.dart';

class SignUp extends ConsumerWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SignUpState>(signUpProvider, (previous, current) { });
    return Column(
      children: const [
        NameField(),
        SizedBox(
          height: 16,
        ),
        EmailField(),
        SizedBox(
          height: 16,
        ),
        PasswordField(),
        SizedBox(
          height: 24,
        ),
        SignUpButton(),
      ],
    );
  }
}
