import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;
  

  //*   Exponer El ServerStatus Para Poder 
  //*   Utilizarlo En Cualquier Parte De La Aplicación

  ServerStatus get serverStatus => this._serverStatus;
  
  IO.Socket get socket => this._socket;
  get emit => this._socket.emit;


  SocketService(  ){  
    this._initConfig();
  }

  void _initConfig() {

    // Dart client
    // IO.Socket socket = IO.io('http://localhost:3000/', {
    // IO.Socket socket = IO.io('http://192.168.0.12:3000/', {
    this._socket = IO.io('http://192.168.0.12:3000/', {
    // this._socket = IO.io('http://192.168.1.59:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

        // socket.onConnect((_) {
    //   print('connect');
    //   socket.emit('msg', 'test');
    // });
    // socket.on('event', (data) => print(data));
    // socket.onDisconnect((_) => print('disconnect'));
    // socket.on('fromServer', (_) => print(_));
    
    this._socket.on('connect', (_) {
      // print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    
    this._socket.on( 'disconnect', (_) {
      // print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    
    // socket.on( 'nuevo-mensaje', ( payload ) {
    //   // print('disconnect');
    //   // print( 'nuevo-mensaje: $payload' );
    //   print( 'nuevo-mensaje' );
    //   print( 'nombre:' + payload['nombre'] );
    //   print( 'mensaje:' + payload['mensaje'] );
    //   print( payload.containsKey('mensaje2') ? payload['mensaje2'] : 'No Hay' );
    // });
    
    
  }

}

