import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';
import 'package:barcode_scan/barcode_scan.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QRReader'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever), 
            onPressed: (){},
            )
        ],
      ),
      body: Center(
        child: _callPage(currentIndex),
      ),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: _scanQR ,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }


  _scanQR() async {
    //https://www.frc.utn.edu.ar
    //geo:40.79080836648317,-73.95924940546878

    dynamic futureString = '';
  
    try{
      futureString = await BarcodeScanner.scan();
    }catch(e){
      futureString = e.toString();
    }

    print('FutureString: ${futureString.rawContent}');

    if(futureString != null){
      print('HAY INFORMACION');
    }

  }

  Widget _crearBottomNavigationBar(){
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas') 
          ),

          BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones') 
          ),
      ],
      );
  }

  Widget _callPage( int paginaActual){
    switch(paginaActual){
      case 0: return MapasPage();
      case 1: return DireccionesPage();
      default: return MapasPage();
    }
  }
}