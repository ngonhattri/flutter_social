import 'package:flutter/material.dart';
import 'package:flutter_social/authentication/signin/signin.dart';
import 'package:flutter_social/authentication/signup/signup.dart';
import 'package:flutter_social/components/animated_button.dart';
import 'package:flutter_social/components/animation_shape/animated_shape.dart';
import 'package:flutter_social/components/auth_switch_button.dart';
import 'package:flutter_social/components/slide_fade_switcher.dart';
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
            child: SlideFadeSwitcher(
                child: _showSignIn ? const SignIn() : const SignUp()),
          ),
          const AnimatedShape(
            color: Color(0xFF595DC6),
            show: true,
            title: "Create Account",
          ),
          AnimatedShape(
            color: const Color(0xFFFC5F8E),
            show: !_showSignIn,
            title: "Welcome Back",
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
