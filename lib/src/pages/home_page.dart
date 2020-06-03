import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/model/scan_model.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';

 
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QRReader'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever), 
            onPressed: scansBloc.borrarScansTodos,
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
        onPressed: () =>_scanQR(context) ,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }


  _scanQR(BuildContext context) async {
    //https://www.frc.utn.edu.ar
    //geo:40.79080836648317,-73.95924940546878

    //dynamic futureString = '';

    String futureString = 'https://www.frc.utn.edu.ar';
  
/*     try{
      futureString = await BarcodeScanner.scan();
    }catch(e){
      futureString = e.toString();
    }

    print('FutureString: ${futureString.rawContent}');
 */
    if(futureString != null){
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);
      
      // final scan2 = ScanModel(valor: 'geo:40.79080836648317,-73.95924940546878');
      // scansBloc.agregarScan(scan2); 

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