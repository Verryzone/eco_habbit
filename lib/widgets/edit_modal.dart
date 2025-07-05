// lib/widgets/add_habit_modal.dart

import 'package:flutter/material.dart';

class EditHabitModal extends StatefulWidget {
  const EditHabitModal({Key? key}) : super(key: key);

  @override
  State<EditHabitModal> createState() => _EditHabitModalState();
}

class _EditHabitModalState extends State<EditHabitModal> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedStatus = 'Reduce';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Habit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text('Name', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 12, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Color(0xFF54861C),
                  width: 2, // Tambahkan ketebalan border
                ),
              ),
              focusColor: Color(0xFF54861C),
            ),
            cursorColor: Color(0xFF54861C),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Color(0xFF54861C),
                  width: 2, // Tambahkan ketebalan border
                ),
              ),
              focusColor: Color(0xFF54861C),
            ),
            items: [
              DropdownMenuItem(value: 'Reduce', child: Text('Reduce')),
              DropdownMenuItem(value: 'Reuse', child: Text('Reuse')),
              DropdownMenuItem(value: 'Recycle', child: Text('Recycle')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedStatus = value;
                });
              }
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Save logic
                print('Saved: ${_nameController.text} - $_selectedStatus');
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC2D9AB),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Update'),
            ),
          ),
        ],
      ),
    );
  }
}
