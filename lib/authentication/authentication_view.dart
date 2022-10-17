import 'package:flutter/material.dart';
import 'package:flutter_social/authentication/signin/signin.dart';
import 'package:flutter_social/authentication/signup/signup.dart';
import 'package:flutter_social/components/animated_button.dart';
import 'package:flutter_social/components/auth_switch_button.dart';
import 'package:flutter_social/components/text_input_field.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  bool _showSignIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              250,
              16,
              0,
            ),
            child: _showSignIn ? SignIn() : SignUp(),
          ),
          AuthSwitchButton(
            showSignIn: _showSignIn,
            onTap: () {
              setState(() {
                _showSignIn = !_showSignIn;
              });
            },
          ),
        ],
      ),
    );
  }
}
