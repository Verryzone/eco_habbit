import 'package:flutter/widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [_buildCard(), const SizedBox(height: 12), _buildCard()],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFC2D9AB),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Using botle',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Text(
            'Reuse',
            style: TextStyle(color: Color.fromARGB(255, 87, 87, 87)),
          ),
          SizedBox(height: 2),
          Text(
            '21-May-2025',
            style: TextStyle(color: Color.fromARGB(255, 87, 87, 87)),
          ),
        ],
      ),
    );
  }
}
