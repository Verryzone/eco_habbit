import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticScreen extends StatelessWidget {
  // Contoh data dinamis
  final List<Map<String, dynamic>> data = [
    {"status": "Reduce", "qty": 28},
    {"status": "Reuse", "qty": 12},
    {"status": "Recycle", "qty": 6},
  ];

  @override
  Widget build(BuildContext context) {
    final int total = data.fold(0, (sum, item) => (sum + item['qty']).toInt());

    final List<Color> colors = [Colors.blue, Colors.orange, Colors.teal];

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 100),
          SizedBox(
            height: 250,
            width: 250, // penting agar Stack tahu ukuran
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Donut Chart
                PieChart(
                  PieChartData(
                    centerSpaceRadius: 90,
                    sections: List.generate(data.length, (index) {
                      final item = data[index];
                      final double percent = (item['qty'] / total) * 100;
                      return PieChartSectionData(
                        color: colors[index],
                        value: item['qty'].toDouble(),
                        // title: "${percent.toStringAsFixed(1)}%",
                        radius: 40,
                        titleStyle: TextStyle(
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
                    Text("Total Habit", style: TextStyle(fontSize: 16)),
                    Text(
                      "$total",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          // Tabel
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Table(
              // Hilangkan semua border
              columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                // HEADER ROW
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: const Color.fromARGB(255, 201, 201, 201),
                      ), // hanya garis bawah header
                    ),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Qty",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "%",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                // DATA ROWS
                ...List.generate(data.length, (index) {
                  final item = data[index];
                  final percent = (item['qty'] / total) * 100;
                  return TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: colors[index],
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(item['status']),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("${item['qty']}"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("${percent.toStringAsFixed(1)}%"),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
