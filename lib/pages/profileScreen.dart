import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Warna utama profil
    final Color primaryColor = const Color(0xFF54861C);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              // Logout logic
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          // Avatar + edit icon
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFC2D9AB),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: primaryColor,
                ),
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Icon(Icons.edit, size: 16, color: primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Name
          Text(
            "Verryzone",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          // Email
          Text(
            "verryzone@gmail.com",
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 30),
          // Menu List
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem("Habbit Total"),
                _buildMenuItem("Rating Activity"),
                _buildMenuItem("Devices"),
                _buildMenuItem("Notifications"),
                _buildMenuItem("Appearance"),
                _buildMenuItem("Language"),
                _buildMenuItem("Privacy & Security"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper buat item menu
  Widget _buildMenuItem(String title) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Navigasi ke halaman lain
          },
        ),
        Divider(height: 1),
      ],
    );
  }
}
