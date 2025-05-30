import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config.dart'; // pour baseUrl

class PanneFormPage extends StatefulWidget {
  const PanneFormPage({super.key});

  @override
  State<PanneFormPage> createState() => _PanneFormPageState();
}

class _PanneFormPageState extends State<PanneFormPage> {
  final _formKey = GlobalKey<FormState>();

  String? tramId;
  String? horaire;
  String type = 'retard';
  String? commentaire;

  List<String> horaires = [];
  List<Map<String, dynamic>> trams = [];

  @override
  void initState() {
    super.initState();
    loadTrams();
  }

  Future<void> loadTrams() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trams'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          trams = data.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Erreur de chargement');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  void handleTramChange(String? value) {
    tramId = value;
    final selected = trams.firstWhere((t) => t['_id'] == value);
    horaires = (selected['schedule'] as List)
        .map((s) => "${s['departureTime']} → ${s['arrivalTime']}")
        .toList();
    horaire = horaires.isNotEmpty ? horaires[0] : null;
    setState(() {});
  }

  Future<void> submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final panne = {
        'tramId': tramId,
        'description': "$type - $horaire\n${commentaire ?? ''}"
      };

      try {
        final response = await http.post(
          Uri.parse('$baseUrl/pannes'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(panne),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Panne signalée avec succès")),
          );
          Navigator.pop(context);
        } else {
          throw Exception("Échec : ${response.body}");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Erreur : $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signaler une panne")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: tramId,
                items: trams.map<DropdownMenuItem<String>>((t) {
                  return DropdownMenuItem<String>(
                    value: t['_id'] as String,
                    child: Text(t['name']),
                  );
                }).toList(),
                onChanged: handleTramChange,
                decoration: const InputDecoration(labelText: 'Tram concerné'),
                validator: (value) => value == null ? 'Choisir un tram' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: horaire,
                items: horaires
                    .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                    .toList(),
                onChanged: (value) => setState(() => horaire = value),
                decoration: const InputDecoration(labelText: 'Horaire concerné'),
                validator: (value) => value == null ? 'Choisir un horaire' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: 'retard', child: Text('Retard')),
                  DropdownMenuItem(value: 'annulation', child: Text('Annulation')),
                  DropdownMenuItem(value: 'autre', child: Text('Autre')),
                ],
                onChanged: (value) => setState(() => type = value!),
                decoration: const InputDecoration(labelText: 'Type de panne'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: "Commentaire (optionnel)"),
                maxLines: 3,
                onSaved: (value) => commentaire = value?.trim(),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.report_problem),
                label: const Text("Envoyer le signalement"),
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
