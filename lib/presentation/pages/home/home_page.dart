import 'package:dictionary/presentation/pages/auth/cubit/auth_cubit.dart';
import 'package:dictionary/presentation/pages/home/widgets/favorites/favorites_page.dart';
import 'package:dictionary/presentation/pages/home/widgets/history/history_page.dart';
import 'package:dictionary/presentation/pages/home/widgets/words_list/words_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentMenuIndex = useState(0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<AuthCubit>(context).signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: currentMenuIndex.value,
          children: const [
            WordsListPage(),
            HistoryPage(),
            FavoritesPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentMenuIndex.value,
        onTap: (value) => currentMenuIndex.value = value,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Words',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
