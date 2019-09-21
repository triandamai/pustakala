import 'package:Pustakala/src/pages/add_produk.dart';
import 'package:flutter/material.dart';

import 'screens/main.screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routes = {
      '/add': (context) => AddProduk(),
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pustakala",
      theme: ThemeData(primaryColor: Colors.blueAccent),
      home: MainScreen(),
      routes: routes,
    );
  }
}
