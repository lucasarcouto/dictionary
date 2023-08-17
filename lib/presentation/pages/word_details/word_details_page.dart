import 'package:dictionary/injection.dart';
import 'package:dictionary/presentation/pages/home/widgets/favorites/cubit/favorites_cubit.dart';
import 'package:dictionary/presentation/pages/word_details/cubit/word_details_cubit.dart';
import 'package:dictionary/presentation/pages/word_details/widgets/word_details_content.dart';
import 'package:dictionary/presentation/pages/word_details/widgets/word_details_content_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WordDetailsPage extends StatelessWidget {
  const WordDetailsPage({
    super.key,
    required this.word,
  });

  final String word;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WordDetailsCubit>(
          create: (BuildContext context) => injection<WordDetailsCubit>(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (BuildContext context) => injection<FavoritesCubit>(),
        ),
      ],
      child: WordDetailsPageContent(word: word),
    );
  }
}

class WordDetailsPageContent extends HookWidget {
  const WordDetailsPageContent({
    super.key,
    required this.word,
  });

  final String word;

  @override
  Widget build(BuildContext context) {
    final wordDetailsCubit = BlocProvider.of<WordDetailsCubit>(context);

    final favoritesCubit = BlocProvider.of<FavoritesCubit>(context);

    useEffect(() {
      final state = wordDetailsCubit.state;

      if (state is WordDetailsInitial) {
        wordDetailsCubit.getWordDetails(word);
      }
      return;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          BlocBuilder<WordDetailsCubit, WordDetailsState>(
            builder: (context, state) {
              if (state is WordDetailsLoaded && state.wordDetails != null) {
                return IconButton(
                  onPressed: () async {
                    if (state.wordDetails!.isFavorite) {
                      await favoritesCubit.removeFavorite(word);
                    } else {
                      await favoritesCubit.addToFavorites(word);
                    }

                    await wordDetailsCubit.getWordDetails(word);
                  },
                  icon: Icon(
                    state.wordDetails!.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_outline,
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<WordDetailsCubit, WordDetailsState>(
          builder: (context, state) {
        if (state is WordDetailsInitial || state is WordDetailsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is WordDetailsLoaded) {
          return WordDetailsContent(wordDetails: state.wordDetails);
        }

        if (state is WordDetailsError) {
          return WordDetailsContentError(errorMessage: state.errorMessage);
        }

        return const SizedBox();
      }),
    );
  }
}
