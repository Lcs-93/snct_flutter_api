import 'package:flutter/material.dart';

class ListeTram extends StatefulWidget {
  const ListeTram({super.key});

  @override
  State<ListeTram> createState() => _ListeTramState();
}

class _ListeTramState extends State<ListeTram> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Accueil')),
        Card(
          child: SizedBox(
            width: 300,
            height: 100,
            child: ListTile(
              leading: Text('P1'),
              title: Text('Card 1'),
              subtitle: Text('Description card 1'),
            ),
          ),
        ),
        Card(
          child: SizedBox(
            width: 300,
            height: 100,
            child: ListTile(
              leading: Text('P2'),
              title: Text('Card 2'),
              subtitle: Text('Description card 2'),
            ),
          ),
        ),
        Card(
          child: SizedBox(
            width: 300,
            height: 100,
            child: ListTile(
              leading: Text('P3'),
              title: Text('Card 3'),
              subtitle: Text('Description card 3'),
            ),
          ),
        ),
      ],
    );
  }
}
