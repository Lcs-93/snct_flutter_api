import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../vues/login_page.dart';
import '../utils/toats.dart';
import 'package:snct/config.dart';

class AuthService {
  static const String apiUrl = "http://localhost:5000/api/users";

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
        await prefs.setString('user', jsonEncode(data['user']));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Erreur de login: $e");
      return false;
    }
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
    final userString = prefs.getString('user');
    if (userString != null) {
      return jsonDecode(userString);
    }
    return null;
  }

  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
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
}
