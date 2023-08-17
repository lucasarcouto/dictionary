import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/core/hooks/use_bloc_subscription.dart';
import 'package:dictionary/core/util/snackbar.dart';
import 'package:dictionary/injection.dart';
import 'package:dictionary/presentation/pages/home/widgets/history/cubit/history_cubit.dart';
import 'package:dictionary/presentation/pages/home/widgets/words_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injection<HistoryCubit>(),
      child: const HistoryPageContent(),
    );
  }
}

class HistoryPageContent extends HookWidget {
  const HistoryPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final history = useState<List<String>>([]);
    final lastHistoryVisible =
        useState<QueryDocumentSnapshot<Map<String, dynamic>>?>(null);

    final scrollController = useScrollController();

    useBlocSubscription<HistoryCubit, HistoryState>(context, (state) {
      if (state is HistoryLoaded) {
        history.value.addAll(state.history.history);

        final newLastHistoryVisible = state.history.lastHistoryVisible;
        if (newLastHistoryVisible != null) {
          lastHistoryVisible.value = newLastHistoryVisible;
        }
        return;
      }

      if (state is HistoryError) {
        showSnackbar(
          context: context,
          message: state.errorMessage,
          type: SnackbarType.failure,
        );
      }
    });

    useEffect(() {
      final state = BlocProvider.of<HistoryCubit>(context).state;

      if (state is HistoryInitial) {
        _getHistory(context);
      }

      return;
    }, []);

    useEffect(() {
      scrollController.addListener(() {
        final scrolledPastLastItem = scrollController.offset >=
            scrollController.position.maxScrollExtent;

        if (scrolledPastLastItem) {
          _getHistory(context, lastHistoryVisible: lastHistoryVisible.value);
        }
      });
      return;
    }, [scrollController]);

    return RefreshIndicator(
      onRefresh: () async {
        history.value = [];
        lastHistoryVisible.value = null;
        await _getHistory(context);
      },
      child: WordsGrid(
        scrollController: scrollController,
        content: history,
        onTap: (word) => context.go('/details/$word'),
      ),
    );
  }
}

Future<void> _getHistory(BuildContext context,
    {QueryDocumentSnapshot<Map<String, dynamic>>? lastHistoryVisible}) async {
  await BlocProvider.of<HistoryCubit>(context).getHistory(
    lastHistoryVisible: lastHistoryVisible,
  );
}
