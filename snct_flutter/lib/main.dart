import 'package:flutter/material.dart';
import 'package:snct/vues/navbar_vues.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SNCT App',
      debugShowCheckedModeBanner: false,
      home: const NavabarVue(),
    );
  }
}
