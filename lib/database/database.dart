import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:financial_tracker/models/transaction.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  final String _tableName = "transactions";
  final String _dbName = "my_transactions.db";

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // final db = await database;
    // await db.execute("ALTER TABLE $_tableName ADD COLUMN cashflow TEXT;");

    await db.execute(/* SQL */ ''' 
    CREATE TABLE $_tableName(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT,
      amount DOUBLE,
      cashflow TEXT,
      datetime TEXT
    )
    ''');
  }

  Future<TransactionModel> insertTransaction(
    TransactionModel transaction,
  ) async {
    final db = await database;
    final id = await db.insert(_tableName, transaction.toJson());

    return TransactionModel(
      id: id,
      description: transaction.description,
      amount: transaction.amount,
      cashFlow: transaction.cashFlow,
    );
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;

    final List<Map<String, dynamic>> json = await db.query(_tableName);

    final List<TransactionModel> transactionList = List.generate(
      json.length,
      (i) => TransactionModel.fromJson(json[i]),
    );

    return transactionList;
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;

    final result = await db.update(
      _tableName,
      transaction.toJson(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );

    return result;
  }

  Future<int> deleteTransaction(TransactionModel transaction) async {
    final db = await database;

    final result = await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [transaction.id],
    );

    return result;
  }
}
