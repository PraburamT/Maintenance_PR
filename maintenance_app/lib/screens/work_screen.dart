import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/work_provider.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkProvider>(context, listen: false).fetchWorks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final plant = GoRouterState.of(context).extra as Map<String, dynamic>;
    final plantCode = plant['Werks'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Work Orders - ${plant['Name1'] ?? 'Plant'}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<WorkProvider>(
        builder: (context, workProvider, child) {
          if (workProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (workProvider.error != null) {
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
                    'Error loading work orders',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    workProvider.error!,
                    style: TextStyle(
                      color: Colors.red[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      workProvider.fetchWorks();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final plantWorks = workProvider.getWorksByPlant(plantCode);

          if (plantWorks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.work_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No work orders found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'There are no work orders for this plant',
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
            onRefresh: () => workProvider.fetchWorks(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: plantWorks.length,
              itemBuilder: (context, index) {
                final work = plantWorks[index];
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
                                color: _getOrderTypeColor(work['Auart']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Icon(
                                Icons.work,
                                color: _getOrderTypeColor(work['Auart']),
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Work Order ${work['Aufnr'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Type: ${work['Auart'] ?? 'N/A'}',
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
                                color: _getOrderTypeColor(work['Auart']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _getOrderTypeColor(work['Auart']).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                work['Auart'] ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getOrderTypeColor(work['Auart']),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        if (work['Ktext'] != null && 
                            work['Ktext'].toString().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              work['Ktext'],
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
                                'Plant',
                                work['Werks'] ?? 'N/A',
                                Icons.factory,
                              ),
                            ),
                            Expanded(
                              child: _buildInfoItem(
                                'Work Center',
                                work['Arbpl'] ?? 'N/A',
                                Icons.work_outline,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(
                                'Start Date',
                                _formatDate(work['Gstrp']),
                                Icons.calendar_today,
                              ),
                            ),
                            Expanded(
                              child: _buildInfoItem(
                                'End Date',
                                _formatDate(work['Gltrp']),
                                Icons.event,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(
                                'Activity Type',
                                work['Ilart'] ?? 'N/A',
                                Icons.build_circle,
                              ),
                            ),
                            const Expanded(child: SizedBox()),
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

  Color _getOrderTypeColor(String? orderType) {
    switch (orderType) {
      case 'PM01':
        return Colors.blue;
      case 'PM02':
        return Colors.green;
      case 'PM03':
        return Colors.orange;
      case 'PM04':
        return Colors.purple;
      default:
        return Colors.grey;
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
