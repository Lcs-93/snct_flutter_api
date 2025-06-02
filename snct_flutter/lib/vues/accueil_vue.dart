import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:snct/models/trams.dart';
import 'package:snct/services/auth_service.dart';

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
  List<Map<String, dynamic>> pannes = [];
  bool isLoggedIn = false;

  List<Trams> parseTram(responseBody) {
    final decoded = json.decode(responseBody);
    return (decoded as List).map((e) => Trams.fromJson(e)).toList();
  }

  Future<List<Trams>> fetchTrams() async {
    final response = await http.get(
      Uri.parse('http://localhost:5050/api/trams'),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200 ? compute(parseTram, response.body) : [];
  }

  Future<void> loadTrams() async {
    final trams = await fetchTrams();
    setState(() {
      listTram = trams;
    });
  }

  Future<void> loadPannes() async {
    final response = await http.get(
      Uri.parse('http://localhost:5050/api/pannes'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        pannes = data.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> checkConnexion() async {
    final userId = await AuthService.getUserId();
    setState(() {
      isLoggedIn = userId != null;
    });
  }

  @override
  void initState() {
    super.initState();
    checkConnexion();
    loadTrams();
    loadPannes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.train, color: Colors.deepPurple, size: 26),
              SizedBox(width: 8),
              Text(
                "Horaires des trains",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Bienvenue sur la plateforme de réservation SNCTram",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.deepPurple),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: listTram.length,
            itemBuilder: (context, index) {
              final tram = listTram[index];

              final panne = pannes.firstWhere(
                (p) => p['tramId']?['_id'] == tram.id,
                orElse: () => {},
              );

              final isDelayed = tram.status == 'Delayed';
              final isDown = tram.status == 'Down';

              final badgeText = isDown ? "Annulation" : "Retard";
              final badgeColor = isDown ? Colors.red : Colors.amber;

              final horaires =
                  (tram.schedule != null && tram.schedule!.isNotEmpty)
                  ? "${tram.schedule![0]['departureTime']} → ${tram.schedule![0]['arrivalTime']}"
                  : null;

              final commentaire = panne['description'] != null
                  ? panne['description'].toString().split('\n').last.trim()
                  : null;

              return Column(
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${tram.from ?? ''} → ${tram.to ?? ''}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      tram.name ?? "Sans nom",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (isDelayed || isDown)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badgeColor.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: badgeColor),
                                  ),
                                  child: Text(
                                    badgeText,
                                    style: TextStyle(
                                      color: badgeColor.shade800,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (horaires != null)
                            Row(
                              children: [
                                const Icon(
                                  Icons.schedule,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  horaires,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          if ((isDelayed || isDown) &&
                              commentaire != null &&
                              commentaire.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                commentaire,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (!isLoggedIn || isDown)
                        ? null
                        : () {
                            Navigator.pushNamed(
                              context,
                              '/detailsTrams',
                              arguments: ArgTrams(
                                tram.id ?? 'Pas id',
                                tram.name ?? 'Pas name',
                                tram.from ?? 'Pas from',
                                tram.status ?? 'Pas status',
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade50,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      isLoggedIn ? "Sélection" : "Connectez-vous pour réserver",
                    ),
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
