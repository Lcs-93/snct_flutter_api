import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:snct/models/billets.dart';
import 'package:http/http.dart' as http;
import 'package:snct/services/auth_service.dart';

class ListBillet extends StatefulWidget {
  const ListBillet({super.key});

  @override
  State<ListBillet> createState() => _ListBilletState();
}

class _ListBilletState extends State<ListBillet> {
  List<Billets> listBillet = [];
  String? idUser;

  List<Billets> parseBillet(reponseBody) {
    var decoded = jsonDecode(reponseBody);
    var list = decoded as List<dynamic>;

    var billet = list.map((e) => Billets.fromJson(e)).toList();
    return billet;
  }

  Future<List<Billets>> getBillets() async {
    idUser = await AuthService.getUserId();
    var reponse = await http.get(
      Uri.parse('http://localhost:5050/api/users/billets/$idUser'),
      headers: {'Content-Type': 'application/json'},
    );

    if (reponse.statusCode == 200) {
      return compute(parseBillet, reponse.body);
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    loadBillet();
  }

  Future<void> loadBillet() async {
    var billet = await getBillets();
    setState(() {
      listBillet = billet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: listBillet.length,
            itemBuilder: (BuildContext context, int index) {
              var billet = listBillet[index];
              return Column(
                children: [
                  Text(billet.idTrams ?? 'Pas d id'),
                  QrImageView(
                    data: billet.idTrams ?? "Inconnue",
                    size: 280,
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: const Size(100, 100),
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
