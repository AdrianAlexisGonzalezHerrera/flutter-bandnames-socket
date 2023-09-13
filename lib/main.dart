import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:band_names/src/services/socket_service.dart';

import 'package:band_names/src/pages/home.dart';
import 'package:band_names/src/pages/status.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        ChangeNotifierProvider(create: ( _ ) => SocketService() )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        // initialRoute: 'status',
        routes: {
          'home': ( _ ) => HomePage(),
          'status':( _ ) => StatusPage()
        },
      ),
    );
  }
}