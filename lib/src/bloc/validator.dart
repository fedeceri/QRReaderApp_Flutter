

import 'dart:async';

import 'package:qrreaderapp/src/model/scan_model.dart';

class Validators{

  //entra una lista de scanmodel y sale una lista de scanmodel filtrada
  final validarGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink){
      final geoScans = scans.where((s) => s.tipo == 'geo').toList(); //filtrar
      sink.add(geoScans);

    }
  );

  final validarHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink){
      final geoScans = scans.where((s) => s.tipo == 'http').toList(); //filtrar
      sink.add(geoScans);

    }
  );
}