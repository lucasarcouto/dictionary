import 'package:flutter/material.dart';

class WordsGrid extends StatelessWidget {
  const WordsGrid({
    super.key,
    required this.scrollController,
    required this.content,
    this.onTap,
  });

  final ScrollController scrollController;
  final ValueNotifier<List<String>> content;
  final Function(String word)? onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: content.value.length,
      itemBuilder: (context, index) {
        final word = content.value[index];

        return GestureDetector(
          onTap: () => onTap?.call(word),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                word,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
    );
  }
}
