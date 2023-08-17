import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/data/models/dictionary_model.dart';

abstract class DictionaryRemoteDatasource {
  Future<DictionaryModel> getWordsList({
    QueryDocumentSnapshot<Map<String, dynamic>>? lastWordVisible,
  });
}

class DictionaryRemoteDatasourceImpl implements DictionaryRemoteDatasource {
  DictionaryRemoteDatasourceImpl(this.firebaseFirestoreInstance);

  final FirebaseFirestore firebaseFirestoreInstance;

  @override
  Future<DictionaryModel> getWordsList(
      {QueryDocumentSnapshot<Map<String, dynamic>>? lastWordVisible}) async {
    QuerySnapshot<Map<String, dynamic>> response;

    final query = firebaseFirestoreInstance
        .collection('dictionary')
        .orderBy(FieldPath.documentId)
        .limit(25);

    if (lastWordVisible != null) {
      response = await query.startAfterDocument(lastWordVisible).get();
    } else {
      response = await query.get();
    }

    return DictionaryModel.fromQuerySnapshot(response);
  }
}
