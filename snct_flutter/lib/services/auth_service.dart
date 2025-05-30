import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/toats.dart';
import 'package:snct/config.dart';
import 'package:snct/vues/navbar_vues.dart';
class AuthService {
  static const String apiUrl = "http://localhost:5050/api/users";

static Future<bool> login(
  BuildContext context,
  String email,
  String password,
) async {
  try {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', data['token']);
      final userJson = data['user'];
      await prefs.setString('user', jsonEncode(userJson));

      if (userJson['_id'] != null) {
        await prefs.setString('userId', userJson['_id']);
      }

      if (userJson['role'] != null) {
        await prefs.setString('role', userJson['role']);
      }

      return true;
    } else {
      return false;
    }
  } catch (e) {
    print("Erreur de login: $e");
    return false;
  }
}

static Future<String?> getUserRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('role');
}

  static Future<bool> register(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Erreur d'inscription: $e");
      return false;
    }
  }

static Future<Map<String, dynamic>?> getUser() async {
  final prefs = await SharedPreferences.getInstance();
  final userStr = prefs.getString('user');
  if (userStr != null) {
    return jsonDecode(userStr);
  }
  return null;
}


static Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

static Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('user');
  await prefs.remove('userId');
  await prefs.remove('role');


  // Redirection vers la page d’accueil (Navbar avec index 0)
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const NavabarVue(initialPageIndex: 0),
    ),
    (route) => false,
  );
}


  static Future<bool> updateName(String newName, BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final res = await http.patch(
        Uri.parse('$baseUrl/users/update-name'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': newName}),
      );

      if (res.statusCode == 200) {
        await prefs.setString('user', res.body);
        return true;
      } else {
        showToast("Erreur lors de la mise à jour du nom");
        return false;
      }
    } catch (e) {
      showToast("Erreur serveur");
      return false;
    }
  }

  static Future<void> deleteAccount(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final res = await http.delete(
        Uri.parse('$baseUrl/users/delete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        showToast("Compte supprimé");
        await logout(context);
      } else {
        showToast("Erreur lors de la suppression");
      }
    } catch (e) {
      showToast("Erreur serveur");
    }
  }
}
