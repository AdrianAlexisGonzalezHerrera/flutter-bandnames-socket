import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:band_names/src/services/socket_service.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    

    return Scaffold(
      body: Center(
        // child: Text('Hola Mundo'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ServerStatus: ${ socketService.serverStatus }')
          ],
        )
     ),
     floatingActionButton: FloatingActionButton(
      child: Icon( Icons.message ),
      onPressed: (){
        // TAREA
        // emitir:
        // { nombre: 'Flutter', mesaje: 'Hola desde Flutter' }
        // socketService.socket.emit('emitir-mensaje', { 'nombre': 'Flutter', 'mensaje': 'Hola Desde Flutter' });
        // socketService.emit('emitir-mensaje', { 'nombre': 'Flutter', 'mensaje': 'Hola Desde Flutter' });
        socketService.socket.emit('emitir-mensaje', { 
          'nombre': 'Flutter', 
          'mensaje': 'Hola Desde Flutter' 
        });

      }
     ),
   );
  }
}