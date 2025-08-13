import 'package:flutter/material.dart';
import '../services/api_service.dart';

class WorkProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _works = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get works => _works;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWorks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _works = await ApiService.getWorkList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _works = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  List<Map<String, dynamic>> getWorksByPlant(String plantCode) {
    return _works.where((work) => 
      work['Werks'] == plantCode
    ).toList();
  }

  Map<String, dynamic>? getWorkByAufnr(String aufnr) {
    try {
      return _works.firstWhere((work) => 
        work['Aufnr'] == aufnr
      );
    } catch (e) {
      return null;
    }
  }
}
