import 'package:drift/drift.dart';

@DataClassName('WordDetails')
class WordDetailsTable extends Table {
  TextColumn get word => text().customConstraint('UNIQUE NOT NULL')();

  TextColumn get json => text()();

  @override
  Set<Column> get primaryKey => {word};
}
