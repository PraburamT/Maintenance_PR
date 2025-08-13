import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  static const String baseUrl = AppConfig.backendUrl;
  
  // Login endpoint
  static const String loginEndpoint = AppConfig.loginEndpoint;
  
  // Plant endpoint
  static const String plantEndpoint = AppConfig.plantEndpoint;
  
  // Notification endpoint
  static const String notificationEndpoint = AppConfig.notificationEndpoint;
  
  // Work endpoint
  static const String workEndpoint = AppConfig.workEndpoint;

  // Login method
  static Future<Map<String, dynamic>> login(String empId, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'EmpId': empId,
          'Password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  // Get plant list
  static Future<List<Map<String, dynamic>>> getPlantList() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$plantEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch plant list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching plant list: $e');
    }
  }

  // Get notification list
  static Future<List<Map<String, dynamic>>> getNotificationList() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$notificationEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch notification list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notification list: $e');
    }
  }

  // Get work list
  static Future<List<Map<String, dynamic>>> getWorkList() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$workEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch work list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching work list: $e');
    }
  }
}
