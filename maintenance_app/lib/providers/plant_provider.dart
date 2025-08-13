import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PlantProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _plants = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get plants => _plants;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPlants() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _plants = await ApiService.getPlantList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _plants = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Map<String, dynamic>? getPlantByWerks(String werks) {
    try {
      return _plants.firstWhere((plant) => plant['Werks'] == werks);
    } catch (e) {
      return null;
    }
  }
}
