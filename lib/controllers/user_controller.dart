import 'dart:convert';
import 'package:freelance/Models/password_change_model.dart';
import 'package:freelance/controllers/auth.dart';
import 'package:http/http.dart' as http;

class UserController {
  final String baseUrl = 'https://smart-attendance-q879.onrender.com/api/v1'; // change to your base API URL

  Future<http.Response> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    try {
      final response = await http.get(url);
      return response;
    } catch (e) {
      throw Exception('GET request error: $e');
    }
  }

  Future<http.Response> postRequest(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      throw Exception('POST request error: $e');
    }
  }

  Future<http.Response> postWithoutBody(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    try {
      final response = await http.post(url);
      return response;
    } catch (e) {
      throw Exception('POST (no body) request error: $e');
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await postRequest('users/login', {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['data']['accessToken']!;
      final userName = data['data']['user']['fullName']!;
      final userEmail = data['data']['user']['email']!;
      AuthService.saveToken(accessToken);
      AuthService.saveUserDetails(name: userName, email: userEmail);
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<bool> registerUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/users/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'fullName': fullName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // Successfully registered
      return true;
    } else {
      // Print error for debug
      // print('Register failed: ${response.body}');
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/users/change-password');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(PasswordChangeRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ).toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      // final error = jsonDecode(response.body);
      return false;
      // throw Exception(error['message'] ?? 'Failed to change password');
    }
  }
}

