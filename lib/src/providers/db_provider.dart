import 'dart:io';
import 'package:qrreaderapp/src/model/scan_model.dart';
export 'package:qrreaderapp/src/model/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider{
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async{
    if(_database != null) return _database;

    _database = await initDB();

    return _database;
  }


  initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path , 'ScansDB.db');

    //si la bd ya existe, esto regresará la bd ya creada previamente.
    //el numero de version indica si al iniciar la bd ya se encuentra creada y hay que usarla, o si hay q aplicar cambios
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Scans ('
          'id INTEGER PRIMARY KEY, '
          'tipo TEXT,'
          'valor TEXT'
          ')'
        );
      }
      );
  }

  //CREAR Registros (version 1)
  nuevoScanRaw(ScanModel nuevoScan) async{
    final db = await database;

    final res = await db.rawInsert(
      "INSERT INTO Scans (id, tipo, valor) "
      "VALUES (${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}' )"
    );
    return res;

  }

  //CREAR Registros (version 2, más simple)(es la que vamos a usar)
  nuevoScan (ScanModel nuevoScan) async{
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  //SELECT - Obtener informacion
  Future<ScanModel> getScanId(int id) async {
    final db = await database;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]); //el signo ? indica que debe ser un argumento
    
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null; //si no está vacío retorna el primer elemento que coincide con el id, si está vacío retorna null
  }

  Future<List<ScanModel>> getTodosScans() async {
    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty 
                                  ? res.map((e) => ScanModel.fromJson(e)).toList()
                                  : [];

    return list;
  }

  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");

    List<ScanModel> list = res.isNotEmpty 
                                  ? res.map((e) => ScanModel.fromJson(e)).toList()
                                  : [];

    return list;
  }

  //Actualizar registros (devuelve un entero con la cantidad de updates realizados)
  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.update('Scans', nuevoScan.toJson(), where: 'id= ?', whereArgs: [nuevoScan.id]);

    return res;
  }

  //Eliminar registros por id (devuelve la cantidad de registros eliminados)
  Future<int> deleteScan (int id) async {
    final db = await database;

    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  //Eliminar todos los registros (devuelve la cantidad de registros eliminados) (vesion con el rawDelete de ejemplo de uso)
  Future<int> deleteAll () async {
    final db = await database;

    final res = await db.rawDelete('DELETE FROM Scans');

    return res;
  }

}