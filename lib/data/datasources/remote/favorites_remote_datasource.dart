import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/data/models/favorites_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FavoritesRemoteDatasource {
  Future<FavoritesModel?> getFavorites({
    QueryDocumentSnapshot<Map<String, dynamic>>? lastFavoriteVisible,
  });
  Future<void> addToFavorites(String word);
  Future<bool> isFavorite(String word);
  Future<void> removeFavorite(String word);
}

class FavoritesRemoteDatasourceImpl implements FavoritesRemoteDatasource {
  FavoritesRemoteDatasourceImpl(
    this.currentUser,
    this.firebaseFirestoreInstance,
  );

  final User? currentUser;
  final FirebaseFirestore firebaseFirestoreInstance;

  @override
  Future<FavoritesModel?> getFavorites(
      {QueryDocumentSnapshot<Map<String, dynamic>>?
          lastFavoriteVisible}) async {
    if (currentUser?.uid == null) {
      throw TypeError();
    }

    QuerySnapshot<Map<String, dynamic>> response;

    final query = firebaseFirestoreInstance
        .collection('users/${currentUser!.uid}/favorites')
        .orderBy(FieldPath.documentId)
        .limit(25);

    if (lastFavoriteVisible != null) {
      response = await query.startAfterDocument(lastFavoriteVisible).get();
    } else {
      response = await query.get();
    }

    return FavoritesModel.fromQuerySnapshot(response);
  }

  @override
  Future<void> addToFavorites(String word) async {
    if (currentUser?.uid == null) {
      throw TypeError();
    }

    await firebaseFirestoreInstance
        .doc('users/${currentUser!.uid}/favorites/$word')
        .set({});
  }

  @override
  Future<bool> isFavorite(String word) async {
    if (currentUser?.uid == null) {
      throw TypeError();
    }

    final response = await firebaseFirestoreInstance
        .collection('users/${currentUser!.uid}/favorites')
        .where(FieldPath.documentId, isEqualTo: word)
        .count()
        .get();

    return response.count > 0;
  }

  @override
  Future<void> removeFavorite(String word) async {
    if (currentUser?.uid == null) {
      throw TypeError();
    }

    await firebaseFirestoreInstance
        .collection('users/${currentUser!.uid}/favorites')
        .doc(word)
        .delete();
  }
}
