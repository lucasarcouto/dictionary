import 'package:flutter/material.dart';

class NoWordDetailsAvailable extends StatelessWidget {
  const NoWordDetailsAvailable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.warning,
              color: Colors.yellow.shade700,
              size: 32,
            ),
            const SizedBox(height: 32),
            const Text(
              'No details available for the selected word',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
