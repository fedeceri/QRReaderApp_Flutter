

import 'dart:async';

import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    //Obtener los scans de la BD
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream;

  dispose(){
    _scansController?.close(); //el ? verifica que tenga algun objeto para que no falle
  }

  

  obtenerScans() async{
    _scansController.sink.add(await DBProvider.db.getTodosScans());

  }

  agregarScan(ScanModel scan) async{
    await DBProvider.db.nuevoScan(scan);
    //Agregar al stream el nuevo scan
    obtenerScans();
  }


  borrarScan(int id) async{
    await DBProvider.db.deleteScan(id);
    obtenerScans(); //regresa los scans actualizados
  }

  borrarScansTodos() async{
    DBProvider.db.deleteAll();
    obtenerScans();
  }

}