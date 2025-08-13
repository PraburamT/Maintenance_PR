import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false).fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final plant = GoRouterState.of(context).extra as Map<String, dynamic>;
    final plantCode = plant['Werks'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications - ${plant['Name1'] ?? 'Plant'}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          if (notificationProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (notificationProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading notifications',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notificationProvider.error!,
                    style: TextStyle(
                      color: Colors.red[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      notificationProvider.fetchNotifications();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final plantNotifications = notificationProvider.getNotificationsByPlant(plantCode);

          if (plantNotifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'There are no notifications for this plant',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => notificationProvider.fetchNotifications(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: plantNotifications.length,
              itemBuilder: (context, index) {
                final notification = plantNotifications[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _getPriorityColor(notification['Priority']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Icon(
                                Icons.notifications,
                                color: _getPriorityColor(notification['Priority']),
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Notification ${notification['Qmnum'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Equipment: ${notification['Equipment'] ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(notification['Priority']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _getPriorityColor(notification['Priority']).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                _getPriorityText(notification['Priority']),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getPriorityColor(notification['Priority']),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        if (notification['Description'] != null && 
                            notification['Description'].toString().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              notification['Description'],
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),

                        const Divider(),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(
                                'Type',
                                notification['QmType'] ?? 'N/A',
                                Icons.category,
                              ),
                            ),
                            Expanded(
                              child: _buildInfoItem(
                                'Group',
                                notification['Ingrp'] ?? 'N/A',
                                Icons.group,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(
                                'Created',
                                _formatDate(notification['CreatedOn']),
                                Icons.calendar_today,
                              ),
                            ),
                            Expanded(
                              child: _buildInfoItem(
                                'Duration',
                                '${notification['Duration'] ?? 'N/A'} days',
                                Icons.schedule,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(
                                'Activity',
                                notification['Artpr'] ?? 'N/A',
                                Icons.build,
                              ),
                            ),
                            Expanded(
                              child: _buildInfoItem(
                                'Work Center',
                                notification['WorkcenterPlant'] ?? 'N/A',
                                Icons.work,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(String? priority) {
    switch (priority) {
      case '1':
        return Colors.red;
      case '2':
        return Colors.orange;
      case '3':
        return Colors.yellow[700]!;
      case '4':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getPriorityText(String? priority) {
    switch (priority) {
      case '1':
        return 'HIGH';
      case '2':
        return 'MEDIUM';
      case '3':
        return 'LOW';
      case '4':
        return 'VERY LOW';
      default:
        return 'UNKNOWN';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    
    try {
      // Assuming the date format from SAP is in a specific format
      // You may need to adjust this based on your actual date format
      return dateString;
    } catch (e) {
      return dateString;
    }
  }
}
