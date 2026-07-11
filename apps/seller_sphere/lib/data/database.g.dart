// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
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

  ProductDao? _productDaoInstance;

  TransactionDao? _transactionDaoInstance;

  TargetDao? _targetDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
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
            'CREATE TABLE IF NOT EXISTS `Product` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `sku` TEXT NOT NULL, `stock` REAL NOT NULL, `minStockThreshold` REAL NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SaleTransaction` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `timestamp` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SaleItem` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `transactionId` INTEGER NOT NULL, `productId` INTEGER NOT NULL, `quantity` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SalesTarget` (`dateString` TEXT NOT NULL, `targetAmount` REAL NOT NULL, PRIMARY KEY (`dateString`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ProductDao get productDao {
    return _productDaoInstance ??= _$ProductDao(database, changeListener);
  }

  @override
  TransactionDao get transactionDao {
    return _transactionDaoInstance ??=
        _$TransactionDao(database, changeListener);
  }

  @override
  TargetDao get targetDao {
    return _targetDaoInstance ??= _$TargetDao(database, changeListener);
  }
}

class _$ProductDao extends ProductDao {
  _$ProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productInsertionAdapter = InsertionAdapter(
            database,
            'Product',
            (Product item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'sku': item.sku,
                  'stock': item.stock,
                  'minStockThreshold': item.minStockThreshold
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Product> _productInsertionAdapter;

  @override
  Future<List<Product>> findAllProducts() async {
    return _queryAdapter.queryList('SELECT * FROM Product',
        mapper: (Map<String, Object?> row) => Product(
            id: row['id'] as int?,
            name: row['name'] as String,
            sku: row['sku'] as String,
            stock: row['stock'] as double,
            minStockThreshold: row['minStockThreshold'] as double));
  }

  @override
  Future<void> insertProduct(Product product) async {
    await _productInsertionAdapter.insert(product, OnConflictStrategy.abort);
  }
}

class _$TransactionDao extends TransactionDao {
  _$TransactionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _saleTransactionInsertionAdapter = InsertionAdapter(
            database,
            'SaleTransaction',
            (SaleTransaction item) =>
                <String, Object?>{'id': item.id, 'timestamp': item.timestamp}),
        _saleItemInsertionAdapter = InsertionAdapter(
            database,
            'SaleItem',
            (SaleItem item) => <String, Object?>{
                  'id': item.id,
                  'transactionId': item.transactionId,
                  'productId': item.productId,
                  'quantity': item.quantity
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SaleTransaction> _saleTransactionInsertionAdapter;

  final InsertionAdapter<SaleItem> _saleItemInsertionAdapter;

  @override
  Future<List<SaleItem>> findItemsForTransaction(int transactionId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM SaleItem WHERE transactionId = ?1',
        mapper: (Map<String, Object?> row) => SaleItem(
            id: row['id'] as int?,
            transactionId: row['transactionId'] as int,
            productId: row['productId'] as int,
            quantity: row['quantity'] as int),
        arguments: [transactionId]);
  }

  @override
  Future<int> insertTransaction(SaleTransaction transaction) {
    return _saleTransactionInsertionAdapter.insertAndReturnId(
        transaction, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertSaleItem(SaleItem item) async {
    await _saleItemInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }
}

class _$TargetDao extends TargetDao {
  _$TargetDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _salesTargetInsertionAdapter = InsertionAdapter(
            database,
            'SalesTarget',
            (SalesTarget item) => <String, Object?>{
                  'dateString': item.dateString,
                  'targetAmount': item.targetAmount
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SalesTarget> _salesTargetInsertionAdapter;

  @override
  Future<SalesTarget?> findTargetByDate(String dateString) async {
    return _queryAdapter.query(
        'SELECT * FROM SalesTarget WHERE dateString = ?1',
        mapper: (Map<String, Object?> row) => SalesTarget(
            dateString: row['dateString'] as String,
            targetAmount: row['targetAmount'] as double),
        arguments: [dateString]);
  }

  @override
  Future<void> insertTarget(SalesTarget target) async {
    await _salesTargetInsertionAdapter.insert(
        target, OnConflictStrategy.replace);
  }
}
