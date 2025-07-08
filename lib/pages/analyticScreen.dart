import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:eco_habbit/controllers/dashboard_controller.dart';
import 'package:eco_habbit/models/habbit_model.dart';

class AnalyticScreen extends StatefulWidget {
  const AnalyticScreen({super.key});

  @override
  State<AnalyticScreen> createState() => _AnalyticScreenState();
}

class _AnalyticScreenState extends State<AnalyticScreen> {
  final DashboardController _controller = DashboardController();
  
  @override
  void initState() {
    super.initState();
    _controller.initialize();
  }

  List<Map<String, dynamic>> _getAnalyticsData(List<HabbitModel> habits, Map<int, String> categoriesMap) {
    // Group habits by category
    Map<String, int> categoryCount = {};
    
    for (var habit in habits) {
      String categoryName = categoriesMap[habit.categoryId] ?? 'Unknown';
      categoryCount[categoryName] = (categoryCount[categoryName] ?? 0) + 1;
    }
    
    // Convert to list of maps
    return categoryCount.entries.map((entry) => {
      'status': entry.key,
      'qty': entry.value,
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
        stream: _controller.loadingStream,
        initialData: _controller.isLoading,
        builder: (context, loadingSnapshot) {
          final isLoading = loadingSnapshot.data ?? false;
          
          return StreamBuilder<List<HabbitModel>>(
            stream: _controller.habitsStream,
            initialData: _controller.habits,
            builder: (context, habitsSnapshot) {
              return StreamBuilder<Map<int, String>>(
                stream: _controller.categoriesStream,
                initialData: _controller.categoriesMap,
                builder: (context, categoriesSnapshot) {
                  final habits = habitsSnapshot.data ?? [];
                  final categoriesMap = categoriesSnapshot.data ?? {};
                  
                  // Show loading state
                  if (isLoading && habits.isEmpty) {
                    return Column(
                      children: [
                        const SizedBox(height: 60),
                        // Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.analytics_rounded,
                                color: Color(0xFF54861C),
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Habits Analytics',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF54861C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF54861C),
                                strokeWidth: 3,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Loading analytics...',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }                  
                  // Show empty state
                  if (habits.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Data Available',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add some habits to see analytics',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              final data = _getAnalyticsData(habits, categoriesMap);
              final int total = habits.length;

              // Generate colors dynamically based on data length
              final List<Color> colors = List.generate(data.length, (index) {
                final baseColors = [
                  Color(0xFF54861C),
                  Colors.blue.shade400,
                  Colors.orange.shade400,
                  Colors.purple.shade400,
                  Colors.teal.shade400,
                  Colors.pink.shade400,
                  Colors.indigo.shade400,
                ];
                return baseColors[index % baseColors.length];
              });

              return Column(
                children: [
                  const SizedBox(height: 60),
                  // Chart Container
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Donut Chart
                        PieChart(
                          PieChartData(
                            centerSpaceRadius: 90,
                            sections: List.generate(data.length, (index) {
                              final item = data[index];
                              return PieChartSectionData(
                                color: colors[index],
                                value: item['qty'].toDouble(),
                                radius: 40,
                                titleStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }),
                            sectionsSpace: 2,
                          ),
                        ),
                        // Center Text
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Total Habits",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              "$total",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF54861C),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Statistics Table
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categories Breakdown',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final item = data[index];
                                final percent = (item['qty'] / total) * 100;
                                
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: colors[index].withOpacity(0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colors[index].withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: colors[index],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item['status'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colors[index].withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "${item['qty']} habits",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: colors[index],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${percent.toStringAsFixed(1)}%",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colors[index],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
                },
              );
            },
          );
        },
      ),
    );
  }
}
