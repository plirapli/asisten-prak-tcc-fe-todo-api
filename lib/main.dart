import 'package:flutter/material.dart';
import 'package:prak_tcc_fe_mobile/theme.dart';
import 'package:prak_tcc_fe_mobile/view/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prak. TCC - Web Service',
      theme: themeData,
      home: const HomePage(),
    );
  }
}
