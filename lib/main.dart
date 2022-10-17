import 'package:flutter/material.dart';
import 'package:flutter_social/authentication/authentication_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: const Color(0xFFFFFFEF4)
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthenticationView(),
    );
  }
}


