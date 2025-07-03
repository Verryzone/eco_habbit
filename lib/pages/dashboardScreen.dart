import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [_buildCard(), const SizedBox(height: 12), _buildCard()],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add action
        },
        backgroundColor: Color(0xFFC2D9AB),
        child: const Icon(Icons.add, color: Color(0xFF54861C)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          Text('Reuse', style: TextStyle(color: Color.fromARGB(255, 87, 87, 87))),
          SizedBox(height: 2),
          Text('21-May-2025', style: TextStyle(color: Color.fromARGB(255, 87, 87, 87))),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F6F7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, isSelected: true),
          _buildNavItem(Icons.history),
          _buildNavItem(Icons.person),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData iconData, {bool isSelected = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFC2D9AB) : Colors.transparent,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Icon(iconData, color: Color(0xFF54861C)),
    );
  }
}
