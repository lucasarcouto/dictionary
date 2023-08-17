import 'package:flutter/material.dart';

enum SnackbarType { notice, success, failure }

/// Shows a [SnackBar] at the bottom of the screen containing a [message]. It
/// will automatically be dismissed, but users can swipe it away.
///
/// WARNING: this method requires a parent Scaffold to be present, otherwise
/// an exception will be thrown.
void showSnackbar(
    {required BuildContext context,
    required String message,
    SnackbarType type = SnackbarType.notice}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _resolveTextColor(type),
              fontWeight: FontWeight.w600,
            ),
      ),
      backgroundColor: _resolveBackgroundColor(type),
    ),
  );
}

Color _resolveTextColor(SnackbarType type) {
  if (type == SnackbarType.failure || type == SnackbarType.success) {
    return Colors.black;
  }

  return Colors.white;
}

Color _resolveBackgroundColor(SnackbarType type) {
  if (type == SnackbarType.failure) return Colors.red.shade500;

  if (type == SnackbarType.success) return Colors.green.shade500;

  return Colors.grey.shade900;
}
