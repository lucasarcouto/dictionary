import 'package:dictionary/core/util/strings.dart';
import 'package:dictionary/domain/entities/word_details_entity.dart';
import 'package:flutter/material.dart';

class WordDetailsDefinitions extends StatelessWidget {
  const WordDetailsDefinitions({
    super.key,
    required this.wordDetails,
  });

  final WordDetailsEntity wordDetails;

  @override
  Widget build(BuildContext context) {
    if (wordDetails.results == null || wordDetails.results!.isEmpty) {
      return const SizedBox();
    }

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Definitions',
            style: theme.textTheme.titleLarge,
          ),
          ...wordDetails.results!
              .asMap()
              .entries
              .map((item) => _WordDefinition(
                    index: item.key,
                    item: item.value,
                  ))
              .toList(),
        ],
      ),
    );
  }
}

class _WordDefinition extends StatelessWidget {
  const _WordDefinition({
    required this.index,
    required this.item,
  });

  final int index;
  final WordResult item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WordPartOfSpeech(index: index, partOfSpeech: item.partOfSpeech),
          const SizedBox(height: 8),
          Text(capitalizeFirstLetter(
              item.definition ?? 'No definition was provided')),
          _WordSynonyms(synonyms: item.synonyms),
          _WordExamples(examples: item.examples),
        ],
      ),
    );
  }
}

class _WordPartOfSpeech extends StatelessWidget {
  const _WordPartOfSpeech({required this.index, this.partOfSpeech});

  final int index;
  final String? partOfSpeech;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        '${index + 1}. ${capitalizeFirstLetter(partOfSpeech ?? '')}',
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _WordSynonyms extends StatelessWidget {
  const _WordSynonyms({this.synonyms});

  final List<String>? synonyms;

  @override
  Widget build(BuildContext context) {
    if (synonyms == null || synonyms!.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text('Synonyms: ${synonyms!.join(', ')}'),
    );
  }
}

class _WordExamples extends StatelessWidget {
  const _WordExamples({this.examples});

  final List<String>? examples;

  String renderExamples() {
    final parsedExamples =
        examples!.map((example) => capitalizeFirstLetter(example)).join('\n •');
    return 'Examples:\n• $parsedExamples';
  }

  @override
  Widget build(BuildContext context) {
    if (examples == null || examples!.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(renderExamples()),
    );
  }
}
