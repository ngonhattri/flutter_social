import 'package:flutter/material.dart';
import 'package:flutter_social/components/text_input_field.dart';

class Email extends StatelessWidget {
  const Email({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextInputField(
      hintText: "Email",
      onChanged: (_) {},
    );
  }
}
