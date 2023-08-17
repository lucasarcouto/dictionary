import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shows an alert dialog to the user with [title] and [message]. It will also
/// have a single with [buttonLabel] that will trigger [onButtonPressed] when
/// it is pressed.
///
/// By default, [dismissable] is false, which means users can only dismiss the
/// dialog by pressing the button at the bottom right.
Future<void> showAlertDialog({
  required BuildContext context,
  bool dismissable = false,
  String? title,
  String? message,
  String? buttonLabel = 'OK',
  VoidCallback? onButtonPressed,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? ''),
        content: Text(message ?? ''),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              onButtonPressed?.call();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
