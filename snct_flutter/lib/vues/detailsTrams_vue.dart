import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snct/services/auth_service.dart';
import 'package:snct/vues/accueil_vue.dart';
import 'package:http/http.dart' as http;

// class DetailsTrams extends StatelessWidget {
//   const DetailsTrams({super.key});

//   static const routeName = '/detailsTrams';

//   @override
//   Widget build(BuildContext context) {
//     final args = ModalRoute.of(context)!.settings.arguments as ArgTrams;
//     return Container(child: Text(args.id));
//   }
// }

class DetailsTrams extends StatefulWidget {
  const DetailsTrams({super.key});

  static const routeName = '/detailsTrams';

  @override
  State<DetailsTrams> createState() => _DetailsTramsState();
}

class _DetailsTramsState extends State<DetailsTrams> {
  String? idUser;

  Future<void> saveQrCodeUser(String id) async {
    idUser = await AuthService.getUserId();
    await http.post(
      Uri.parse('http://localhost:5050/api/users/save-qrcode'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"idUser": idUser, "idTrams": id}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ArgTrams;
    return Column(
      children: [
        Card(
          child: SizedBox(
            width: 300,
            height: 100,
            child: ListTile(
              leading: Text(args.from),
              title: Text(args.name),
              subtitle: Text(args.status),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => {saveQrCodeUser(args.id)},
          child: Text('Acheter billet'),
        ),
      ],
    );
  }
}
