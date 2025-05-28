import 'package:flutter/material.dart';

class NavabarVue extends StatefulWidget {
  const NavabarVue({super.key});

  @override
  State<NavabarVue> createState() => _NavabarVueState();
}

class _NavabarVueState extends State<NavabarVue> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 141, 205, 255),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Acceuil'),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number),
            label: 'Billets',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Compte'),
        ],
      ),
      body: <Widget>[
        Card(child: Center(child: Text('Acceuil'))),
        Card(child: Center(child: Text('Billet'))),
        Card(child: Center(child: Text('Compte'))),
      ][currentPageIndex],
    );
  }
}
