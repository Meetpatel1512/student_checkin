import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student_model.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static const String url = 'http://192.168.1.11:3000';

  static Future<bool> addStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse('$url/students'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(student.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        debugPrint("Failed to add student:${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error adding student:$e");
      return false;
    }
  }

  static Future<Map<String, String>?> getPincodeDetails(String pincode) async {
    try {
      final url = Uri.parse('https://api.postalpincode.in/pincode/$pincode');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty && data[0]['Status'] == 'Success') {
          final postOffice = data[0]['PostOffice'][0];

          return {
            'District': postOffice['District'],
            'State': postOffice['State'],
            'Country': postOffice['Country'],
          };
        }
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching pincode: $e");
      return null;
    }
  }

  static Future<List<Student>> fetchStudentsData() async {
    try {
      final response = await http.get(Uri.parse('$url/students'));

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Student.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load students");
      }
    } catch (e) {
      debugPrint("Error fetching students:$e");
      return [];
    }
  }

  static Future<String> checkInStudent(String studentId) async {
    try {
      final response = await http.post(
        Uri.parse('$url/checkin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'studentId': studentId}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return "success";
      } else {
        return data['message'] ??
            data['error'] ??
            "Check-in failed (Unknown Error)";
      }
    } catch (e) {
      return "error:$e";
    }
  }

  static Future<List<Map<String, dynamic>>> getCheckIns() async {
    try {
      final response = await http.get(Uri.parse('$url/checkins'));

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$url/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Login error: $e");
      return false;
    }
  }
}
