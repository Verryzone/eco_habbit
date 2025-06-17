import 'package:flutter/material.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'Dashboard Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home, color: Color(0xFF54861C),), label: 'Home',),
        BottomNavigationBarItem(icon: Icon(Icons.addchart, color: Color(0xFF54861C),), label: 'Statistics'),
        BottomNavigationBarItem(icon: Icon(Icons.person, color: Color(0xFF54861C),), label: 'Profile'),
      ],
      backgroundColor: Color(0xffF5F6F7),
      // fixedColor: Color(0xFF54861C),
      ),
    );
  }
}