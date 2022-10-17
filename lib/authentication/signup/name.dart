import 'package:flutter/material.dart';
import 'package:flutter_social/components/text_input_field.dart';

class Name extends StatelessWidget {
  const Name({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextInputField(
      hintText: "Name",
      onChanged: (_) {},
    );
  }
}
