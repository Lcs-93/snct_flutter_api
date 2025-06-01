import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snct/services/auth_service.dart';
import 'package:snct/vues/accueil_vue.dart';

class DetailsTrams extends StatefulWidget {
  const DetailsTrams({super.key});
  static const routeName = '/detailsTrams';

  @override
  State<DetailsTrams> createState() => _DetailsTramsState();
}

class _DetailsTramsState extends State<DetailsTrams> {
  String? idUser;
  String? selectedSchedule;
  Map<String, dynamic>? tramData;

  Future<void> saveQrCodeUser(String idTram) async {
    idUser = await AuthService.getUserId();

    if (selectedSchedule == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez choisir un horaire")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5050/api/users/save-qrcode'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "idUser": idUser,
          "idTrams": idTram,
          "schedule": selectedSchedule,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Billet réservé avec succès !")),
        );
        Navigator.pop(context);
      } else {
        throw Exception("Erreur : ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  Future<void> fetchTramData(String id) async {
    final response =
        await http.get(Uri.parse('http://localhost:5050/api/trams/$id'));
    if (response.statusCode == 200) {
      setState(() {
        tramData = jsonDecode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)!.settings.arguments as ArgTrams;
      fetchTramData(args.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ArgTrams;

    return Scaffold(
      appBar: AppBar(title: const Text("Détails du train")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: tramData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${tramData!['from']} → ${tramData!['to']}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Statut : ${tramData!['status']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: tramData!['status'] == 'OK'
                                  ? Colors.green
                                  : tramData!['status'] == 'Delayed'
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (tramData!['schedule'] != null &&
                      tramData!['schedule'] is List)
                    DropdownButtonFormField<String>(
                      value: selectedSchedule,
                      items: (tramData!['schedule'] as List)
                          .map((h) => DropdownMenuItem<String>(
                                value:
                                    "${h['departureTime']} → ${h['arrivalTime']}",
                                child: Text(
                                    "${h['departureTime']} → ${h['arrivalTime']}"),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedSchedule = value),
                      decoration: const InputDecoration(
                        labelText: 'Horaire de réservation',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text("Réserver ce billet"),
                    onPressed: () => saveQrCodeUser(args.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
