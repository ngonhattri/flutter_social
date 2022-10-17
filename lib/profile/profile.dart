import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("user id"),
            Text("user email"),
            Text("email verified"),
            TextButton(
              onPressed: () {},
              child: const Text("Signout"),
            ),
          ],
        ),
      ),
    );
  }
}
