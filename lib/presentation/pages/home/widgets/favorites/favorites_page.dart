import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/core/hooks/use_bloc_subscription.dart';
import 'package:dictionary/core/util/snackbar.dart';
import 'package:dictionary/injection.dart';
import 'package:dictionary/presentation/pages/home/widgets/favorites/cubit/favorites_cubit.dart';
import 'package:dictionary/presentation/pages/home/widgets/words_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injection<FavoritesCubit>(),
      child: const FavoritesPageContent(),
    );
  }
}

class FavoritesPageContent extends HookWidget {
  const FavoritesPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = useState<List<String>>([]);
    final lastFavoriteVisible =
        useState<QueryDocumentSnapshot<Map<String, dynamic>>?>(null);

    final scrollController = useScrollController();

    useBlocSubscription<FavoritesCubit, FavoritesState>(context, (state) {
      if (state is FavoritesLoaded) {
        favorites.value.addAll(state.favorites.favorites);

        final newLastFavoriteVisible = state.favorites.lastFavoriteVisible;
        if (newLastFavoriteVisible != null) {
          lastFavoriteVisible.value = newLastFavoriteVisible;
        }
        return;
      }

      if (state is FavoritesError) {
        showSnackbar(
          context: context,
          message: state.errorMessage,
          type: SnackbarType.failure,
        );
      }
    });

    useEffect(() {
      final state = BlocProvider.of<FavoritesCubit>(context).state;

      if (state is FavoritesInitial) {
        _getFavorites(context);
      }

      return;
    }, []);

    useEffect(() {
      scrollController.addListener(() {
        final scrolledPastLastItem = scrollController.offset >=
            scrollController.position.maxScrollExtent;

        if (scrolledPastLastItem) {
          _getFavorites(context,
              lastFavoriteVisible: lastFavoriteVisible.value);
        }
      });
      return;
    }, [scrollController]);

    return RefreshIndicator(
      onRefresh: () async {
        favorites.value = [];
        lastFavoriteVisible.value = null;
        await _getFavorites(context);
      },
      child: WordsGrid(
        scrollController: scrollController,
        content: favorites,
        onTap: (word) => context.go('/details/$word'),
      ),
    );
  }
}

Future<void> _getFavorites(BuildContext context,
    {QueryDocumentSnapshot<Map<String, dynamic>>? lastFavoriteVisible}) async {
  await BlocProvider.of<FavoritesCubit>(context).getFavorites(
    lastFavoriteVisible: lastFavoriteVisible,
  );
}
