import 'package:flutter/material.dart';

class ListeTram extends StatefulWidget {
  const ListeTram({super.key});

  @override
  State<ListeTram> createState() => _ListeTramState();
}

class _ListeTramState extends State<ListeTram> {
<<<<<<< HEAD
  final List<String> leanding = <String>['A', 'B', 'C'];
  final List<String> title = <String>['Card A', 'Card B', 'Card C'];
  final List<String> subtitle = <String>['Subtitle A', 'Sub B', 'Sub C'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: leanding.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Card(
              child: SizedBox(
                width: 300,
                height: 100,
                child: ListTile(
                  leading: Text('${leanding[index]}'),
                  title: Text('${title[index]}'),
                  subtitle: Text('${subtitle[index]}'),
                ),
              ),
            ),
          ],
        );
      },
=======
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
>>>>>>> d45b42925dd7df01568adb949a219e5d094e9b4c
    );
  }
}
