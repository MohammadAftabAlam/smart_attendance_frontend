import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceController {
  final String baseUrl = 'https://smart-attendance-q879.onrender.com/api/v1/user/attendance';

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<List<dynamic>> fetchAttendance() async {
    final token = await _getAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    final url = Uri.parse('$baseUrl/attendance-details');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['data'];
    } else {
      throw Exception('Failed to load attendance');
    }
  }

  Future<List<dynamic>> fetchAbsentAttendance() async {
    final token = await _getAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    final url = Uri.parse('$baseUrl/absent-details');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['data'];
    } else {
      throw Exception('Failed to load absent entries');
    }
  }


  Future<void> markAsPresent() async {
    final token = await _getAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    final url = Uri.parse('$baseUrl/present');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark attendance');
    }
  }


}
