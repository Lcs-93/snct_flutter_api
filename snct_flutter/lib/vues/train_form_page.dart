import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class TrainFormPage extends StatefulWidget {
  const TrainFormPage({super.key});

  @override
  State<TrainFormPage> createState() => _TrainFormPageState();
}

class _TrainFormPageState extends State<TrainFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  List<Map<String, TimeOfDay>> horaires = [];

  @override
  void initState() {
    super.initState();
    addHoraire();
  }

  void addHoraire() {
    setState(() {
      horaires.add({'departure': TimeOfDay.now(), 'arrival': TimeOfDay.now()});
    });
  }

  void removeHoraire(int index) {
    setState(() {
      horaires.removeAt(index);
    });
  }

  String formatTime24h(TimeOfDay t) {
  final hour = t.hour.toString().padLeft(2, '0');
  final minute = t.minute.toString().padLeft(2, '0');
  return "$hour:$minute";
 }

Future<void> submitTrain() async {
  if (_formKey.currentState!.validate()) {
    final schedule = horaires
        .map((h) => {
              'departureTime': formatTime24h(h['departure']!),
              'arrivalTime': formatTime24h(h['arrival']!),
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
        throw Exception("Erreur : ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Erreur : $e")),
      );
    }
  }
}


  Widget horaireWidget(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Heure de départ"),
        TimePickerSpinner(
          is24HourMode: true,
          normalTextStyle: const TextStyle(fontSize: 18, color: Colors.grey),
          highlightedTextStyle:
              const TextStyle(fontSize: 24, color: Colors.deepPurple),
          spacing: 40,
          itemHeight: 40,
          isForce2Digits: true,
          time: DateTime(2022, 1, 1, horaires[index]['departure']!.hour,
              horaires[index]['departure']!.minute),
          onTimeChange: (time) {
            setState(() {
              horaires[index]['departure'] = TimeOfDay.fromDateTime(time);
            });
          },
        ),
        const SizedBox(height: 8),
        const Text("Heure d’arrivée"),
        TimePickerSpinner(
          is24HourMode: true,
          normalTextStyle: const TextStyle(fontSize: 18, color: Colors.grey),
          highlightedTextStyle:
              const TextStyle(fontSize: 24, color: Colors.deepPurple),
          spacing: 40,
          itemHeight: 40,
          isForce2Digits: true,
          time: DateTime(2022, 1, 1, horaires[index]['arrival']!.hour,
              horaires[index]['arrival']!.minute),
          onTimeChange: (time) {
            setState(() {
              horaires[index]['arrival'] = TimeOfDay.fromDateTime(time);
            });
          },
        ),
        IconButton(
          onPressed: () => removeHoraire(index),
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
        const Divider(),
      ],
    );
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
                decoration: const InputDecoration(
                  labelText: "Nom du train",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Champ requis" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _fromController,
                decoration: const InputDecoration(
                  labelText: "Lieu de départ",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Champ requis" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _toController,
                decoration: const InputDecoration(
                  labelText: "Destination",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Champ requis" : null,
              ),
              const SizedBox(height: 20),
              const Text("Horaires", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...List.generate(horaires.length, (index) => horaireWidget(index)),
              TextButton.icon(
                onPressed: addHoraire,
                icon: const Icon(Icons.add),
                label: const Text("Ajouter un horaire"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitTrain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Créer le train"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
