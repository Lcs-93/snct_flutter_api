import 'package:flutter/material.dart';

class ListeTram extends StatefulWidget {
  const ListeTram({super.key});

  @override
  State<ListeTram> createState() => _ListeTramState();
}

class _ListeTramState extends State<ListeTram> {
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
    );
  }
}
