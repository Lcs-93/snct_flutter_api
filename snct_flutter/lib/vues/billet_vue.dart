import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:snct/services/auth_service.dart';

class ListBillet extends StatefulWidget {
  const ListBillet({super.key});

  @override
  State<ListBillet> createState() => _ListBilletState();
}

class _ListBilletState extends State<ListBillet> {
  List<dynamic> billets = [];
  String? idUser;

  Future<void> loadBillets() async {
    idUser = await AuthService.getUserId();

    final response = await http.get(
      Uri.parse('http://localhost:5050/api/users/billets/$idUser'),
    );

    if (response.statusCode == 200) {
      setState(() {
        billets = jsonDecode(response.body);
        print(billets);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors du chargement des billets")),
      );
    }
  }

  Future<void> cancelBillet(String idTram) async {
    idUser = await AuthService.getUserId();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5050/api/users/cancel-billet'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"idUser": idUser, "idTrams": idTram}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Billet annulé avec succès")),
        );
        loadBillets();
      } else {
        throw Exception("Erreur ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur d'annulation : $e")));
    }
  }

  String jsonData = jsonEncode({
    "type": "billet_tram",
    "idUser": "abc123",
    "idTrams": "tram456",
    "validUntil": "2025-06-03T23:59:59Z",
  });

  @override
  void initState() {
    super.initState();
    loadBillets();
  }

  @override
  Widget build(BuildContext context) {
    return billets.isEmpty
        ? const Center(child: Text("Aucun billet réservé"))
        : ListView.builder(
            itemCount: billets.length,
            itemBuilder: (context, index) {
              final billet = billets[index];
              final tram = billet['tram'];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tram != null
                                ? "${tram['from']} → ${tram['to']}"
                                : "Destination inconnue",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Icon(Icons.train, color: Colors.deepPurple),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tram != null
                            ? tram['name'] ?? "Sans nom"
                            : "Nom inconnu",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        billet['schedule'] != null
                            ? billet['schedule']
                            : "Horaire inconnu",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: QrImageView(data: jsonEncode(billet), size: 180),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          label: const Text(
                            "Annuler la réservation",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () => cancelBillet(billet['idTrams']),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
