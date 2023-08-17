import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/core/auth/auth_service.dart';
import 'package:dictionary/data/database/dao/word_details_dao.dart';
import 'package:dictionary/data/database/database.dart';
import 'package:dictionary/data/datasources/local/word_details_local_datasource.dart';
import 'package:dictionary/data/datasources/remote/auth_remote_datasource.dart';
import 'package:dictionary/data/datasources/remote/dictionary_remote_datasource.dart';
import 'package:dictionary/data/datasources/remote/favorites_remote_datasource.dart';
import 'package:dictionary/data/datasources/remote/history_remote_datasource.dart';
import 'package:dictionary/data/datasources/remote/word_details_remote_datasource.dart';
import 'package:dictionary/data/repositories/auth_repository_impl.dart';
import 'package:dictionary/data/repositories/dictionary_repository_impl.dart';
import 'package:dictionary/data/repositories/favorites_repository_impl.dart';
import 'package:dictionary/data/repositories/history_repository_impl.dart';
import 'package:dictionary/data/repositories/word_details_repository_impl.dart';
import 'package:dictionary/domain/repositories/auth_repository.dart';
import 'package:dictionary/domain/repositories/dictionary_repository.dart';
import 'package:dictionary/domain/repositories/favorites_repository.dart';
import 'package:dictionary/domain/repositories/history_repository.dart';
import 'package:dictionary/domain/repositories/word_details_repository.dart';
import 'package:dictionary/domain/usecases/auth_usecases.dart';
import 'package:dictionary/domain/usecases/dictionary_usecases.dart';
import 'package:dictionary/domain/usecases/favorites_usecases.dart';
import 'package:dictionary/domain/usecases/history_usecases.dart';
import 'package:dictionary/domain/usecases/word_details_usecases.dart';
import 'package:dictionary/presentation/pages/auth/cubit/auth_cubit.dart';
import 'package:dictionary/presentation/pages/home/widgets/favorites/cubit/favorites_cubit.dart';
import 'package:dictionary/presentation/pages/home/widgets/history/cubit/history_cubit.dart';
import 'package:dictionary/presentation/pages/home/widgets/words_list/cubit/words_list_cubit.dart';
import 'package:dictionary/presentation/pages/word_details/cubit/word_details_cubit.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final injection = GetIt.instance;

Future<void> init() async {
  //! Application layer
  injection.registerFactory(() => AuthCubit(injection()));
  injection.registerFactory(() => FavoritesCubit(injection()));
  injection.registerFactory(() => HistoryCubit(injection()));
  injection.registerFactory(() => WordsListCubit(injection()));
  injection.registerFactory(() => WordDetailsCubit(
        wordDetailsUseCases: injection(),
        historyUseCases: injection(),
        favoritesUseCases: injection(),
      ));

  //! Domain layer
  injection.registerFactory(() => AuthUseCases(injection()));
  injection.registerFactory(() => DictionaryUseCases(injection()));
  injection.registerFactory(() => FavoritesUseCases(injection()));
  injection.registerFactory(() => HistoryUseCases(injection()));
  injection.registerFactory(() => WordDetailsUseCases(injection()));

  //! Data layer
  injection
      .registerFactory<AuthRepository>(() => AuthRepositoryImpl(injection()));
  injection.registerFactory<DictionaryRepository>(
      () => DictionaryRepositoryImpl(injection()));
  injection.registerFactory<FavoritesRepository>(
      () => FavoritesRepositoryImpl(injection()));
  injection.registerFactory<HistoryRepository>(
      () => HistoryRepositoryImpl(injection()));
  injection
      .registerFactory<WordDetailsRepository>(() => WordDetailsRepositoryImpl(
            remoteDatasource: injection(),
            localDatasource: injection(),
          ));

  injection.registerFactory<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(injection()));
  injection.registerFactory<DictionaryRemoteDatasource>(
      () => DictionaryRemoteDatasourceImpl(injection()));
  injection.registerFactory<FavoritesRemoteDatasource>(
      () => FavoritesRemoteDatasourceImpl(
            injection<FirebaseAuth>().currentUser,
            injection(),
          ));
  injection.registerFactory<HistoryRemoteDatasource>(
      () => HistoryRemoteDatasourceImpl(
            injection<FirebaseAuth>().currentUser,
            injection(),
          ));
  injection.registerFactory<WordDetailsRemoteDatasource>(
      () => WordDetailsRemoteDatasourceImpl(injection()));

  injection.registerFactory<WordDetailsLocalDatasource>(
      () => WordDetailsLocalDatasourceImpl(injection()));

  injection.registerFactory<WordDetailsDao>(() => WordDetailsDao(injection()));

  injection.registerLazySingleton<AppDatabase>(() => AppDatabase());

  //! Data layer
  injection.registerFactory<AuthService>(() => AuthService(injection()));

  //! Externals
  injection
      .registerFactory<FirebaseFirestore>(() => FirebaseFirestore.instance);
  injection.registerFactory<FirebaseAuth>(() => FirebaseAuth.instance);
  injection.registerFactory<Dio>(() => Dio());
}
