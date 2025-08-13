import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await ApiService.getNotificationList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _notifications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  List<Map<String, dynamic>> getNotificationsByPlant(String plantCode) {
    return _notifications.where((notification) => 
      notification['Iwerk'] == plantCode
    ).toList();
  }

  Map<String, dynamic>? getNotificationByQmnum(String qmnum) {
    try {
      return _notifications.firstWhere((notification) => 
        notification['Qmnum'] == qmnum
      );
    } catch (e) {
      return null;
    }
  }
}
