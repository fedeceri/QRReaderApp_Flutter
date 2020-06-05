import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/model/scan_model.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = new MapController();

  String tipoMapa = 'streets-v11';
  //String tipoMapa = 'satellite-streets-v11';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location), 
            onPressed: (){
              map.move(scan.getLatLng(), 15);
            }
            )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearBotonFlotante (BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
        //street, dark, light, outdoors, satellite, satellite-streets
        switch (tipoMapa){
          case 'streets-v11': {tipoMapa = 'dark-v10';}
          break;

          case 'dark-v10' : {tipoMapa = 'light-v10';}
          break;

          case 'light-v10' : {tipoMapa = 'outdoors-v11';}
          break;

          case 'outdoors-v11' : {tipoMapa = 'satellite-v9';}
          break;

          case 'satellite-v9' : {tipoMapa = 'satellite-streets-v11';}
          break;

          default: {tipoMapa = 'streets-v11';}
          break;
        }

        setState((){});
      }
      );
  }

  Widget _crearFlutterMap(ScanModel scan){
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 10
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan)
      ],
      );
  }

  _crearMapa(){
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
      additionalOptions: {
        'accessToken': 'pk.eyJ1IjoiZmVkZWNlIiwiYSI6ImNrYXlrdWptdjAzb3AzM2tucHFyczA4YmoifQ.twg7qhYsV4bKakNH7f5uqg',
        'id': 'mapbox/$tipoMapa'
      }
    );
  }

  _crearMarcadores(ScanModel scan){
    return MarkerLayerOptions(
      markers: <Marker> [
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(Icons.location_on, size: 45.0, color: Theme.of(context).primaryColor,),
          )
        ),
      ]
      );
  }
}