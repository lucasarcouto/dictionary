import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/core/hooks/use_bloc_subscription.dart';
import 'package:dictionary/core/util/snackbar.dart';
import 'package:dictionary/injection.dart';
import 'package:dictionary/presentation/pages/home/widgets/words_grid.dart';
import 'package:dictionary/presentation/pages/home/widgets/words_list/cubit/words_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class WordsListPage extends StatelessWidget {
  const WordsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injection<WordsListCubit>(),
      child: const WordsListPageContent(),
    );
  }
}

class WordsListPageContent extends HookWidget {
  const WordsListPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final wordsList = useState<List<String>>([]);
    final lastWordVisible =
        useState<QueryDocumentSnapshot<Map<String, dynamic>>?>(null);

    final scrollController = useScrollController();

    useBlocSubscription<WordsListCubit, WordsListState>(context, (state) {
      if (state is WordsListInitial) {
        _getWordsList(context, lastWordVisible: lastWordVisible.value);
      }

      if (state is WordsListLoaded) {
        wordsList.value.addAll(state.dictionary.words);

        final newLastWordVisible = state.dictionary.lastWordVisible;
        if (newLastWordVisible != null) {
          lastWordVisible.value = newLastWordVisible;
        }
        return;
      }

      if (state is WordsListError) {
        showSnackbar(
          context: context,
          message: state.errorMessage,
          type: SnackbarType.failure,
        );
      }
    });

    useEffect(() {
      final state = BlocProvider.of<WordsListCubit>(context).state;

      if (state is WordsListInitial) {
        _getWordsList(context);
      }

      return;
    }, []);

    useEffect(() {
      scrollController.addListener(() {
        final scrolledPastLastItem = scrollController.offset >=
            scrollController.position.maxScrollExtent;

        if (scrolledPastLastItem) {
          _getWordsList(context, lastWordVisible: lastWordVisible.value);
        }
      });
      return;
    }, [scrollController]);

    return RefreshIndicator(
      onRefresh: () async {
        wordsList.value = [];
        lastWordVisible.value = null;
        _getWordsList(context);
      },
      child: WordsGrid(
        scrollController: scrollController,
        content: wordsList,
        onTap: (word) => context.go('/details/$word'),
      ),
    );
  }
}

Future<void> _getWordsList(BuildContext context,
    {QueryDocumentSnapshot<Map<String, dynamic>>? lastWordVisible}) async {
  await BlocProvider.of<WordsListCubit>(context).getWordsList(
    lastWordVisible: lastWordVisible,
  );
}
