import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social/components/animated_button.dart';
import 'package:flutter_social/components/loading_error.dart';
import 'package:flutter_social/components/rounded_button_style.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: () {
        ErrorDialog.show(context, "failed loading");
      },
      child: RoundedButtonStyle(
        title: "Sign In",
      ),
    );
  }
}


