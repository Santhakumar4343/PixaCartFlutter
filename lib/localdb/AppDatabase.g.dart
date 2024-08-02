// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  DaoAccess? _daoaccessInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ListEntity` ('
                'regno INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
                'variant_id TEXT NOT NULL, '
                'sellerId TEXT NOT NULL, '
                'prod_unitprice TEXT NOT NULL, '
                'prod_discount_type TEXT NOT NULL, '
                'selectedSize TEXT NOT NULL, '
                'selectedPrice TEXT NOT NULL, '
                'prod_quantity TEXT NOT NULL, '
                'order_quantity TEXT NOT NULL, '
                'prod_image TEXT NOT NULL, '
                'prod_name TEXT NOT NULL, '
                'prod_discount TEXT NOT NULL, '
                'prod_strikeout_price TEXT NOT NULL, '
                'isLiked INTEGER NOT NULL'
                ')'
        );

        await callback?.onCreate?.call(database, version);
      },

    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DaoAccess get daoaccess {
    return _daoaccessInstance ??= _$DaoAccess(database, changeListener);
  }
}


class _$DaoAccess extends DaoAccess {
  _$DaoAccess(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _listEntityInsertionAdapter = InsertionAdapter(
            database,
            'ListEntity',
                (ListEntity item) => <String, Object?>{
              'regno': item.regno,
              'variant_id': item.variant_id,
              'sellerId': item.sellerId,
              'prod_unitprice': item.prod_unitprice,
              'prod_discount_type': item.prod_discount_type,
              'selectedSize': item.selectedSize,
              'selectedPrice': item.selectedPrice,
              'prod_quantity': item.prod_quantity,
              'order_quantity': item.order_quantity,
              'prod_image': item.prod_image,
              'prod_name': item.prod_name,
              'prod_discount': item.prod_discount,
              'prod_strikeout_price': item.prod_strikeout_price,
              'isLiked': item.isLiked
            }),
        _listEntityUpdateAdapter = UpdateAdapter(
            database,
            'ListEntity',
            ['regno'],
                (ListEntity item) => <String, Object?>{
              'regno': item.regno,
              'variant_id': item.variant_id,
              'sellerId': item.sellerId,
              'prod_unitprice': item.prod_unitprice,
              'prod_discount_type': item.prod_discount_type,
              'selectedSize': item.selectedSize,
              'selectedPrice': item.selectedPrice,
              'prod_quantity': item.prod_quantity,
              'order_quantity': item.order_quantity,
              'prod_image': item.prod_image,
              'prod_name': item.prod_name,
              'prod_discount': item.prod_discount,
              'prod_strikeout_price': item.prod_strikeout_price,
              'isLiked': item.isLiked
            }),
        _listEntityDeletionAdapter = DeletionAdapter(
            database,
            'ListEntity',
            ['regno'],
                (ListEntity item) => <String, Object?>{
              'regno': item.regno,
              'variant_id': item.variant_id,
              'sellerId': item.sellerId,
              'prod_unitprice': item.prod_unitprice,
              'prod_discount_type': item.prod_discount_type,
              'selectedSize': item.selectedSize,
              'selectedPrice': item.selectedPrice,
              'prod_quantity': item.prod_quantity,
              'order_quantity': item.order_quantity,
              'prod_image': item.prod_image,
              'prod_name': item.prod_name,
              'prod_discount': item.prod_discount,
              'prod_strikeout_price': item.prod_strikeout_price,
              'isLiked': item.isLiked
            });

  final sqflite.DatabaseExecutor database;
  final StreamController<String> changeListener;
  final QueryAdapter _queryAdapter;
  final InsertionAdapter<ListEntity> _listEntityInsertionAdapter;
  final UpdateAdapter<ListEntity> _listEntityUpdateAdapter;
  final DeletionAdapter<ListEntity> _listEntityDeletionAdapter;

  @override
  Future<List<ListEntity>> findAllList(String variant_id, String selectedSize) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ListEntity WHERE variant_id = ?1 AND selectedSize = ?2',
        mapper: (Map<String, Object?> row) => ListEntity(
            regno: row['regno'] as int?,
            variant_id: row['variant_id'] as String,
            sellerId: row['sellerId'] as String,
            prod_unitprice: row['prod_unitprice'] as String,
            prod_discount_type: row['prod_discount_type'] as String,
            selectedSize: row['selectedSize'] as String,
            selectedPrice: row['selectedPrice'] as String,
            order_quantity: row['order_quantity'] as String,
            prod_quantity: row['prod_quantity'] as String,
            prod_image: row['prod_image'] as String,
            prod_name: row['prod_name'] as String,
            prod_discount: row['prod_discount'] as String,
            prod_strikeout_price: row['prod_strikeout_price'] as String,
            isLiked: row['isLiked'] as int),
        arguments: [variant_id, selectedSize]);
  }

  @override
  Future<List<ListEntity>> getAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM ListEntity',
        mapper: (Map<String, Object?> row) => ListEntity(
            regno: row['regno'] as int?,
            variant_id: row['variant_id'] as String,
            sellerId: row['sellerId'] as String,
            prod_unitprice: row['prod_unitprice'] as String,
            prod_discount_type: row['prod_discount_type'] as String,
            selectedSize: row['selectedSize'] as String,
            selectedPrice: row['selectedPrice'] as String,
            order_quantity: row['order_quantity'] as String,
            prod_quantity: row['prod_quantity'] as String,
            prod_image: row['prod_image'] as String,
            prod_name: row['prod_name'] as String,
            prod_discount: row['prod_discount'] as String,
            prod_strikeout_price: row['prod_strikeout_price'] as String,
            isLiked: row['isLiked'] as int));
  }

  @override
  Future<void> insertInList(ListEntity list) async {
    await _listEntityInsertionAdapter.insert(list, OnConflictStrategy.abort);
  }

  @override
  Future<void> delete(String variant_id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM ListEntity WHERE variant_id = ?1',
        arguments: [variant_id]);
  }

  @override
  Future<void> updateList(String order_quantity, String variant_id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE ListEntity SET order_quantity = ?1 WHERE variant_id = ?2',
        arguments: [order_quantity, variant_id]);
  }
}




