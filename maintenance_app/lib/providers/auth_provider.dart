import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _empId;
  String? _message;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get empId => _empId;
  String? get message => _message;
  String? get error => _error;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _empId = prefs.getString('empId');
    _isAuthenticated = _empId != null;
    notifyListeners();
  }

  Future<bool> login(String empId, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await ApiService.login(empId, password);
      
      // Debug: Print the actual response to understand what we're getting
      print('Login response: $result');
      
      // Check if login was successful - be very strict about success conditions
      final message = result['Message']?.toString() ?? '';
      
      // Only allow login if message indicates success
      if (message.toUpperCase().contains('SUCCESS') || 
          message.toLowerCase().contains('login successful')) {
        _isAuthenticated = true;
        _empId = empId;
        _message = result['Message'];
        
        // Store EmpId in local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('empId', empId);
        
        _error = null;
      } else {
        _isAuthenticated = false;
        _error = result['Message'] ?? 'Invalid credentials';
        _message = null;
      }
    } catch (e) {
      _isAuthenticated = false;
      _error = e.toString();
      _message = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _isAuthenticated;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _empId = null;
    _message = null;
    _error = null;
    
    // Clear local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('empId');
    
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
