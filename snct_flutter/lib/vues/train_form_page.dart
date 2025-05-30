import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart'; // baseUrl

class TrainFormPage extends StatefulWidget {
  const TrainFormPage({super.key});

  @override
  State<TrainFormPage> createState() => _TrainFormPageState();
}

class _TrainFormPageState extends State<TrainFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  List<Map<String, TextEditingController>> horaires = [];

  @override
  void initState() {
    super.initState();
    addHoraire(); // au moins un horaire par défaut
  }

  void addHoraire() {
    setState(() {
      horaires.add({
        'departure': TextEditingController(),
        'arrival': TextEditingController(),
      });
    });
  }

  void removeHoraire(int index) {
    setState(() {
      horaires.removeAt(index);
    });
  }

Future<void> submitTrain() async {
  if (_formKey.currentState!.validate()) {
    final schedule = horaires
        .map((h) => {
              'departureTime': h['departure']!.text.trim(),
              'arrivalTime': h['arrival']!.text.trim()
            })
        .toList();

    final trainData = {
      'name': _nameController.text.trim(),
      'from': _fromController.text.trim(),
      'to': _toController.text.trim(),
      'schedule': schedule,
      'status': 'OK'
    };

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$baseUrl/trams'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(trainData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Train créé avec succès")),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Erreur : ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Erreur d’envoi : $e")),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un nouveau train')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nom du train"),
                validator: (value) => value!.isEmpty ? "Champ requis" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _fromController,
                decoration: const InputDecoration(labelText: "Lieu de départ"),
                validator: (value) => value!.isEmpty ? "Champ requis" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _toController,
                decoration: const InputDecoration(labelText: "Destination"),
                validator: (value) => value!.isEmpty ? "Champ requis" : null,
              ),
              const SizedBox(height: 20),
              const Text("Horaires", style: TextStyle(fontWeight: FontWeight.bold)),
              ...horaires.asMap().entries.map((entry) {
                final i = entry.key;
                final h = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: h['departure'],
                        decoration: const InputDecoration(labelText: "Départ (ex: 08:00)"),
                        validator: (value) => value!.isEmpty ? "Requis" : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: h['arrival'],
                        decoration: const InputDecoration(labelText: "Arrivée (ex: 11:00)"),
                        validator: (value) => value!.isEmpty ? "Requis" : null,
                      ),
                    ),
                    IconButton(
                      onPressed: () => removeHoraire(i),
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                );
              }),
              TextButton.icon(
                onPressed: addHoraire,
                icon: const Icon(Icons.add),
                label: const Text("Ajouter un horaire"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitTrain,
                child: const Text("Créer le train"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
