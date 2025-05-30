import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:snct/models/trams.dart';

class ArgTrams {
  final String id;
  final String name;
  final String from;
  final String status;

  ArgTrams(this.id, this.name, this.from, this.status);
}

class ListeTram extends StatefulWidget {
  const ListeTram({super.key});

  @override
  State<ListeTram> createState() => _ListeTramState();
}

class _ListeTramState extends State<ListeTram> {
  List<Trams> listTram = [];
  String? idTram;

  List<Trams> parseTram(reponseBody) {
    print(reponseBody);
    var decoded = json.decode(reponseBody);
    var list = decoded as List<dynamic>;

    var trams = list.map((e) => Trams.fromJson(e)).toList();
    return trams;
  }

  Future<List<Trams>> fetchTrams() async {
    var reponse = await http.get(
      Uri.parse('http://localhost:5050/api/trams'),
      headers: {'Content-Type': 'application/json'},
    );

    if (reponse.statusCode == 200) {
      return compute(parseTram, reponse.body);
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    loadTrams();
  }

  // static Future<String?> getIdTram() async {
  //   var idUser = await SharedPreferences.getInstance();
  //   return idUser.getString('userId');
  // }

  Future<void> loadTrams() async {
    var trams = await fetchTrams();
    setState(() {
      listTram = trams;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: listTram.length,
            itemBuilder: (BuildContext context, int index) {
              var tram = listTram[index];
              return Column(
                children: [
                  Card(
                    child: SizedBox(
                      width: 300,
                      height: 100,
                      child: ListTile(
                        leading: Text(tram.from ?? "Pas from"),
                        title: Text(tram.name ?? "Sans nom"),
                        subtitle: Text(tram.status ?? "Pas de statut"),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.pushNamed(
                        context,
                        '/detailsTrams',
                        arguments: ArgTrams(
                          tram.id ?? 'Pas id',
                          tram.name ?? 'Pas name',
                          tram.from ?? "Pas from",
                          tram.status ?? "Pas status",
                        ),
                      ),
                    },
                    child: Text('Séléction'),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
