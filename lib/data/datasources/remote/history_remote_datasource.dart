import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/data/models/history_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class HistoryRemoteDatasource {
  Future<HistoryModel?> getHistory({
    QueryDocumentSnapshot<Map<String, dynamic>>? lastHistoryVisible,
  });
  Future<void> addToHistory(String word);
}

class HistoryRemoteDatasourceImpl implements HistoryRemoteDatasource {
  HistoryRemoteDatasourceImpl(
    this.currentUser,
    this.firebaseFirestoreInstance,
  );

  final User? currentUser;
  final FirebaseFirestore firebaseFirestoreInstance;

  @override
  Future<HistoryModel?> getHistory(
      {DocumentSnapshot? lastHistoryVisible}) async {
    if (currentUser?.uid == null) {
      throw Exception('Current user is not signed in');
    }

    QuerySnapshot<Map<String, dynamic>> response;

    final query = firebaseFirestoreInstance
        .collection('users/${currentUser!.uid}/history')
        .orderBy(FieldPath.documentId)
        .limit(25);

    if (lastHistoryVisible != null) {
      response = await query.startAfterDocument(lastHistoryVisible).get();
    } else {
      response = await query.get();
    }

    return HistoryModel.fromQuerySnapshot(response);
  }

  @override
  Future<void> addToHistory(String word) async {
    if (currentUser?.uid == null) {
      throw Exception('Current user is not signed in');
    }

    await firebaseFirestoreInstance
        .doc('users/${currentUser!.uid}/history/$word')
        .set({});
  }
}
