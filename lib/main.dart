import 'package:cdb/login.dart';
import 'package:flutter/material.dart';

import 'route.dart';

void main() {
  runApp(MyApp());
}

// Main Class Rendering

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Central Dashboard',
      theme: ThemeData( 
        primarySwatch: Colors.blue,
        // primaryColorDark: Color(0xff283643),
        fontFamily: 'Open Sans'
      ),
      routes: routes,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    );
  }
}
 

 
