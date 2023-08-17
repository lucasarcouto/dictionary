import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final contents = jsonDecode(await rootBundle.loadString(
                  'assets/new_words_dictionary.json')) as Map<String, dynamic>;

              final startIndex = contents.entries
                      .toList()
                      .indexWhere((element) => element.value == 'psychoses') +
                  1;
              print(contents.entries.elementAt(startIndex));

              for (int i = startIndex; i < contents.entries.length; i++) {
                print(contents.entries.elementAt(i));
                await put(contents.entries.elementAt(i).value);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

Future<QueryDocumentSnapshot<Map<String, dynamic>>>? query(
    QueryDocumentSnapshot<Map<String, dynamic>>? lastVisible) async {
  QueryDocumentSnapshot<Map<String, dynamic>>? result;

  final db = FirebaseFirestore.instance;

  if (lastVisible != null) {
    final response = await db
        .collection('dictionary')
        .orderBy(FieldPath.documentId)
        .limit(1)
        .startAfterDocument(lastVisible)
        .get();

    result = response.docs[0];
  } else {
    final response = await db
        .collection('dictionary')
        .orderBy(FieldPath.documentId)
        .limit(1)
        .get();

    result = response.docs[0];
  }

  return result;
}

Future<void> put(String word) async {
  final collection = FirebaseFirestore.instance.collection('dictionary');
  await collection.doc(word).set({});
}
