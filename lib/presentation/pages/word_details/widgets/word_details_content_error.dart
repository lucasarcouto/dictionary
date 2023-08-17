import 'package:dictionary/domain/failures/failures.dart';
import 'package:flutter/material.dart';

class WordDetailsContentError extends StatelessWidget {
  const WordDetailsContentError({
    super.key,
    required this.errorMessage,
  });

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 32,
            ),
            const SizedBox(height: 32),
            Text(
              errorMessage ?? defaultGeneralFailureMessage,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
