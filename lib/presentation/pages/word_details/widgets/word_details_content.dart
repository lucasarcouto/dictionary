import 'package:dictionary/domain/entities/word_details_entity.dart';
import 'package:dictionary/presentation/pages/word_details/widgets/no_word_details_available.dart';
import 'package:dictionary/presentation/pages/word_details/widgets/word_details_definitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordDetailsContent extends HookWidget {
  const WordDetailsContent({
    super.key,
    required this.wordDetails,
  });

  final WordDetailsEntity? wordDetails;

  @override
  Widget build(BuildContext context) {
    final isPlaying = useState(false);

    final theme = Theme.of(context);

    final details = wordDetails;

    if (details == null) {
      return const NoWordDetailsAvailable();
    }

    final haveWordSyllables =
        details.syllables?.list != null && details.syllables!.list!.isNotEmpty;
    final haveWordPronunciation = details.pronunciation?.all != null;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        details.word,
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: haveWordSyllables ? 16 : 0,
                      ),
                      child: Text(
                        details.syllables?.list?.join(' • ') ?? '',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: haveWordPronunciation ? 16 : 0,
                      ),
                      child: Text(
                        details.pronunciation?.all ?? '',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      onPressed: () => _playWord(details.word, isPlaying),
                      icon:
                          Icon(isPlaying.value ? Icons.stop : Icons.play_arrow),
                    ),
                  ],
                ),
              ),
              WordDetailsDefinitions(wordDetails: details),
            ],
          ),
        ),
      ),
    );
  }
}

void _playWord(String word, ValueNotifier<bool> isPlaying) async {
  final flutterTts = FlutterTts();

  if (isPlaying.value) {
    await flutterTts.stop();
    isPlaying.value = false;
    return;
  }

  // Set up for iOS
  await flutterTts.setSharedInstance(true);
  await flutterTts.setIosAudioCategory(
    IosTextToSpeechAudioCategory.ambient,
    [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      IosTextToSpeechAudioCategoryOptions.mixWithOthers
    ],
    IosTextToSpeechAudioMode.voicePrompt,
  );

  await flutterTts.setVolume(1.0);

  flutterTts.completionHandler = () {
    isPlaying.value = false;
  };

  if (word.isNotEmpty) {
    final result = await flutterTts.speak(word);

    if (result == 1) {
      isPlaying.value = true;
    }
  }
}
