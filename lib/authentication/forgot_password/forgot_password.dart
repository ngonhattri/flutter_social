import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social/authentication/forgot_password/controller/forgot_password_controller.dart';
import 'package:flutter_social/components/text_input_field.dart';
import 'package:form_validators/form_validators.dart';

class ForgotPasswordView extends ConsumerWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  String _getButtonText(FormzStatus status) {
    if(status.isSubmissionSuccess) {
      return "requesting";
    } else if (status.isSubmissionFailure) {
      return "failed";
    } else if(status.isSubmissionSuccess) {
      return "done";
    } else {
      return "request";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forgotPasswordState = ref.watch(forgotPasswordProvider);
    final status = forgotPasswordState.status;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextInputField(
                hintText: "Please enter your email",
                errorText:
                    Email.showEmaiErrorMessage(forgotPasswordState.email.error),
                onChanged: (email) {
                  ref
                      .read(forgotPasswordProvider.notifier)
                      .onEmailChange(email);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: status.isSubmissionInProgress
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: status.isSubmissionInProgress ||
                            status.isSubmissionSuccess
                        ? null
                        : () {
                      ref.read(forgotPasswordProvider.notifier).forgotPassword();
                    },
                    child: Text(_getButtonText(status)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
