import 'package:eco_habbit/widgets/add_modal.dart';
import 'package:eco_habbit/widgets/edit_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF54861C);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          _buildSlidableCard(context),
          const SizedBox(height: 12),
          _buildSlidableCard(context),
        ],
      ),
    );
  }

  Widget _buildSlidableCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Slidable(
        key: UniqueKey(), // wajib unik per item
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.4, // Lebar tombol swipe relatif
          children: [
            SlidableAction(
              onPressed: (context) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => const EditHabitModal(),
                );
              },
              backgroundColor: Colors.yellow.shade700,
              foregroundColor: Colors.white,
              icon: Icons.edit,
            ),
            SlidableAction(
              onPressed: (context) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Delete tapped')));
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
          ],
        ),
        child: Container(
          width: double.infinity, // Biar lebarnya penuh
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFC2D9AB)),
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
        ),
      ),
    );
  }
}
