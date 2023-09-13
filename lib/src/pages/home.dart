import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:band_names/src/models/band.dart';
import 'package:band_names/src/services/socket_service.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    // Band(id: '1', name: 'Metallica', votes: 5),
    // Band(id: '2', name: 'Queen', votes: 1),
    // Band(id: '3', name: 'Héroes del Silencio', votes: 2),
    // Band(id: '4', name: 'Bon Jovi', votes: 5),
  ];

  @override
  void initState() {
    
    final socketService = Provider.of<SocketService>(context, listen: false );

    // socketService.socket.on( 'active-bands', ( payload ) {
    socketService.socket.on( 'active-bands', _handleActiveBands );
    super.initState();
  }

  _handleActiveBands( dynamic payload ) {
    
    this.bands = ( payload as List )
        .map( ( band ) => Band.fromMap( band ) )
        .toList();

    setState(() {});
  }

  @override
  void dispose() {    //* Realiza La Limpieza
    final socketService = Provider.of<SocketService>(context, listen: false );
    socketService.socket.off( 'active-bands' );
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

   // print( socketService);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text( 'BandNames', style: TextStyle( color: Colors.black87 ) ),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only( right: 10 ),
            
            child: ( socketService.serverStatus == ServerStatus.Online )
               ? Icon( Icons.check_circle, color: Colors.blue[300], ) 
               : Icon( Icons.offline_bolt, color: Colors.red, ),
                
               // ( socketService.serverStatus == ServerStatus.Online ) 
               // ? Icon( Icons.check_circle, color: Colors.blue[300], ) 
          )
        ],
      ),
      body: Column(
        children: [

          _showGraph(),

          Expanded(
            child: ListView.builder(
               itemCount: bands.length,   //* Para Quitar El Error RangeError(index)
               // itemBuilder: (BuildContext context, int index) {
          //      
               //   return _bandTile( bands[index] );
               // }
               itemBuilder: ( context, i ) => _bandTile( bands[i] )
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add),
        elevation: 1,
        // onPressed: (){
        //   addNewBand();
        // }
        onPressed: addNewBand  //* Se Envia Solo La Referencia
      ),
   );
  }

  // ListTile _bandTile( Band band) {
  Widget _bandTile( Band band) {
    
    final socketService = Provider.of<SocketService>(context, listen: false );

    return Dismissible(       //*   Permite Deslizar Las Obsiones del Menú
      key: Key(band.id),
      direction: DismissDirection.startToEnd,   //*   Indica La Direccion En La Cual Se Debe Deslizar
      // onDismissed: ( direction ){
      onDismissed: ( _ ){
        // print('dirección: $direction');
        // print('id: ${ band.id }');
        socketService.socket.emit('delete-band', { 'id': band.id } );
      },
      background: Container(
        padding: EdgeInsets.only( left: 8.0 ),
        color: Colors.red,
        // child: Text('Delete Band'),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle( color: Colors.white),),
        )
      ),
      child: ListTile(
         leading: CircleAvatar(
           child: Text( band.name.substring(0,2) ),
           backgroundColor: Colors.blue[100],
         ),
         title: Text( band.name ),
         trailing: Text('${ band.votes }', style: TextStyle( fontSize: 20 ) ),
         onTap: () {
           // print( band.name );
           print( band.id );
           socketService.socket.emit( 'vote-band', { 'id': band.id } );
         },
       ),
    );
  }

  addNewBand(){
    // print('???????');

    final textController = new TextEditingController();

    if ( Platform.isAndroid ) {
      //*   Android
      return showDialog(
        context: context, 
        builder: ( context ) {
          return AlertDialog(
            title: Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                child: Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
                // onPressed: (){
                //   print( textController.text );
                // }  
                onPressed: () => addBandToList( textController.text )        
              )
            ],
          );
        }
      );
    }

    showCupertinoDialog(
      context: context, 
      builder: ( _ ) {
        return CupertinoAlertDialog(
          title: Text('New band name:'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: () => addBandToList( textController.text ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Dismiss'),
              onPressed: () => Navigator.pop(context)
            )
          ],
        );
      }
    );

  }

  void addBandToList( String name ) {
    // print( name );

    final socketService = Provider.of<SocketService>(context, listen: false );

    if ( name.length > 1 ) {
      //   Podemos Agregar
      // this.bands.add( new Band(id: DateTime.now().toString(), name: name, votes: 0 ) );
      // setState(() {});

      socketService.socket.emit( 'add-band', { 'name': name } );


    }

    Navigator.pop(context);

  }


  //*  Mostrar Gráfica

  Widget _showGraph(  ){

    //final socketService = Provider.of(context, listen: false);

   // Map<String, double> dataMap = {
   // 'Flutter': 5,
   // 'React': 3,
   // 'Xamarin': 2,
   // 'Ionic': 2,    
  //
   // 
   // };
   Map<String, double> dataMap = new Map();
   bands.forEach((band) {
     dataMap.putIfAbsent( band.name, () => band.votes.toDouble() );
    
   });
// itemCount: bands.length;   //* Para Quitar El Error RangeError(index)
// itemBuilder: ( context, i ) => _bandTile( bands[i] );
    return Container(
      padding: EdgeInsets.only( top: 10 ),
      width: double.infinity,
      height: 200,

      // child: PieChart(dataMap: dataMap)
      child: PieChart(
        dataMap: dataMap,
        chartType: ChartType.ring,
      )
    ); 

  }




}