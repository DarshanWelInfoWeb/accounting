import 'dart:async';
import 'package:gas_accounting/data/model/body/add_tempinvoice.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/model/body/route.dart';

class DbManager {
  Database? _database;

  Future<Database?> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await openDb();
    return _database;
  }

  Future openDb() async {
    _database = await openDatabase(join(await getDatabasesPath(), "routes.db"),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE model(id INTEGER PRIMARY KEY autoincrement,intRouteId INTEGER,intStockItemId INTEGER,itemName TEXT, strName TEXT,intQuantity INTEGER)",
          );
        });
    // print('db location : $_database');
    return _database;
  }

  Future insertModel(InsertStock_Body model) async {
    await openDb();
    model.intStockItemId = await _database!.insert('model', model.toJson());
    print('model list : ${model.itemName}:::${ConflictAlgorithm.replace}');
    return model;
  }
  Future<List<InsertStock_Body>> getModelList() async {
    await openDb();
    final  List<Map<String, dynamic>> maps = await _database!.query('model',columns: ['id','intRouteId','intStockItemId','itemName','strName','intQuantity']);
    return List.generate(maps.length, (i) {
      print("map::1:::${maps.toList().toString()}::::::${maps[i]['itemName']}");
      return InsertStock_Body(
          id: maps[i]['id'],
          intRouteId: maps[i]['intRouteId'],
          intStockItemId: maps[i]['intStockItemId'],
          itemName: maps[i]['itemName'],
          strName: maps[i]['strName'],
          intQuantity: maps[i]['intQuantity']);
    }).toList();
  }

  Future<List<InsertStock_Body>> getStudents() async {
    await openDb();
    List<Map<String, dynamic>> maps = await _database!.query('model',columns: ['id','intRouteId','intStockItemId','itemName','intQuantity']);
    AppConstants.cart_list.clear();
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        AppConstants.cart_list.add(InsertStock_Body.fromJson(maps[i]));
      }
      print("object:::::::d:::${maps.length}");
    }
    return AppConstants.cart_list;
  }

  Future<int> updateModel(InsertStock_Body model) async {
    await openDb();
    return await _database!.update('model', model.toJson(),
        where: "intStockItemId = ?", whereArgs: [model.intStockItemId]);
  }

  Future<void> deleteModel(InsertStock_Body model) async {
    await openDb();
    print("delete::${model}");
    await _database!.delete('model', where: "id = ?", whereArgs: [model.id]);
  }

  Future close() async {
    var dbClient = _database;
    dbClient!.close();
  }

  Future deleteAll() async {
    var dbClient = await db;
    dbClient!.delete('model');
  }
}

class TempDb {
  Database? _database;

  Future<Database?> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await openTempDb();
    return _database;
  }

  Future openTempDb() async {
    _database = await openDatabase(join(await getDatabasesPath(), "tempStock.db"),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE temp(id INTEGER PRIMARY KEY autoincrement,inttempinvoiceId INTEGER,intItemsDetails INTEGER,name TEXT,strName TEXT,decQty INTEGER,decRate INTEGER,decAmount INTEGER)",
          );
        });
    // print('database location::: $_database');
    return _database;
  }

  Future insertStock(TempStock_Body model) async {
    await openTempDb();
    model.intItemsDetails = await _database!.insert('temp', model.toJson());
    print('model list : $model');
    return model;
  }
  Future<List<TempStock_Body>> getStockList() async {
    await openTempDb();
    final  List<Map<String, dynamic>> maps = await _database!.query('temp',columns: ['id','inttempinvoiceId','intItemsDetails','name','strName','decQty','decRate','decAmount']);
    return List.generate(maps.length, (i) {
      print("map::1:::${maps.toList().toString()}::::::${maps[i]['name']}");
      return TempStock_Body(
          id: maps[i]['id'],
          inttempinvoiceId: maps[i]['inttempinvoiceId'],
          intItemsDetails: maps[i]['intItemsDetails'],
          name: maps[i]['name'],
          strName: maps[i]['strName'],
          decQty: maps[i]['decQty'],
          decRate: maps[i]['decRate'],
          decAmount: maps[i]['decAmount']);
    }).toList();
  }


  Future<int> updateStock(TempStock_Body model) async {
    await openTempDb();
    return await _database!.update('temp', model.toJson(),
        where: "id = ?", whereArgs: [model.intItemsDetails]);
  }

  Future<void> deleteStock(TempStock_Body model) async {
    await openTempDb();
    print("delete::$model");
    await _database!.delete('temp', where: "id = ?", whereArgs: [model.id]);
  }

  Future closeStock() async {
    var dbClient = _database;
    dbClient!.close();
  }

  Future deleteAllStock() async {
    var dbClient = await db;
    dbClient!.delete('temp');
  }
}

class InvoiceStockDb {
  Database? _database;

  Future<Database?> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await openInvoiceStockDb();
    return _database;
  }

  Future openInvoiceStockDb() async {
    _database = await openDatabase(join(await getDatabasesPath(), "invoiceStock.db"),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE invoiceStock(id INTEGER PRIMARY KEY autoincrement,strHSNCode TEXT,intitemid INTEGER,intItemsDetails INTEGER,name TEXT,strName TEXT,decQty INTEGER,decRate INTEGER,decAmount INTEGER,intcompanyid INTEGER)",
          );
        });
    // print('database location::: $_database');
    return _database;
  }

  Future insertInvoiceStock(MainInvoiceStockBody model) async {
    await openInvoiceStockDb();
    model.intitemid = await _database!.insert('invoiceStock', model.toJson());
    print('model list : $model');
    return model;
  }

  Future<List<MainInvoiceStockBody>> getInvoiceStockList() async {
    await openInvoiceStockDb();
    final  List<Map<String, dynamic>> maps = await _database!.query('invoiceStock',columns: ['id','strHSNCode','intitemid','name','decQty','decRate','decAmount','intcompanyid']);
    return List.generate(maps.length, (i) {
      print("List:::${maps.toList().toString()}::::::${maps[i]['name']}");
      return MainInvoiceStockBody(
          id: maps[i]['id'],
          strHSNCode: maps[i]['strHSNCode'],
          intitemid: maps[i]['intitemid'],
          name: maps[i]['name'],
          strName: maps[i]['strName'],
          decQty: maps[i]['decQty'],
          decRate: maps[i]['decRate'],
          decAmount: maps[i]['decAmount'],
          intcompanyid: maps[i]['intcompanyid']);
    }).toList();
  }

  Future<int> updateInvoiceStock(MainInvoiceStockBody model) async {
    await openInvoiceStockDb();
    return await _database!.update('invoiceStock', model.toJson(),
        where: "id = ?", whereArgs: [model.id]);
  }

  Future<void> deleteInvoiceStock(MainInvoiceStockBody model) async {
    await openInvoiceStockDb();
    print("delete::$model");
    await _database!.delete('invoiceStock', where: "id = ?", whereArgs: [model.id]);
  }

  Future closeStock() async {
    var dbClient = _database;
    dbClient!.close();
  }

  Future deleteAllInvoiceStock() async {
    var dbClient = await db;
    dbClient!.delete('invoiceStock');
  }
}
