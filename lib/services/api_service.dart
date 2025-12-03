import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student_model.dart';

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
        print("Failed to add student:${response.body}");
        return false;
      }
    } catch (e) {
      print("Error adding student:$e");
      return false;
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
      print("Error fetching students:$e");
      return [];
    }
  }
}
