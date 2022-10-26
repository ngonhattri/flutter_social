import 'package:flutter/material.dart';
import 'package:flutter_social/authentication/authentication_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social/authentication/controller/authentication_controller.dart';
import 'package:flutter_social/screens/feed_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticationState = ref.watch(authProvider);
    final authUser = ref.watch(authProvider).user;
    Widget getHome() {
      if(authenticationState.status == AuthenticationStatus.authenticated) {
        return FeedScreen(currentUserId: authUser.id);
      } else if (authenticationState.status == AuthenticationStatus.unauthenticated) {
        return const AuthenticationView();
      } else {
        return const AuthenticationView();
      }
    }
    return MaterialApp(
      theme: ThemeData(
        canvasColor: const Color(0xffffffef4)
      ),
      debugShowCheckedModeBanner: false,
      home: getHome(),
    );
  }
}


