import 'package:eco_habbit/models/category_model.dart';
import 'package:eco_habbit/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddHabitModal extends StatefulWidget {
  const AddHabitModal({Key? key}) : super(key: key);

  @override
  State<AddHabitModal> createState() => _AddHabitModalState();
}

class _AddHabitModalState extends State<AddHabitModal> {
  final TextEditingController _nameController = TextEditingController();
  final DashboardController _controller = DashboardController();
  String? _selectedCategoryId;
  List<CategoryModel> _categories = [];
  bool _isLoadingCategories = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      // Get categories from controller instead of service
      final categoriesMap = _controller.categoriesMap;
      final categories = categoriesMap.entries
          .map((entry) => CategoryModel(id: entry.key, name: entry.value))
          .toList();

      setState(() {
        _categories = categories;
        _selectedCategoryId = _categories.isNotEmpty
            ? _categories[0].id.toString()
            : null;
        _isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
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
              controller: _nameController,
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
              value: _selectedCategoryId,
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
              items: _isLoadingCategories
                  ? []
                  : _categories
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat.id.toString(),
                            child: Text(cat.name),
                          ),
                        )
                        .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving
                    ? null
                    : () async {
                        if (_nameController.text.trim().isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please enter a habit name",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.only(top: 4, right: 4, left: 4),
                          );
                          return;
                        }

                        if (_selectedCategoryId == null) {
                          Get.snackbar(
                            "Error",
                            "Please select a category",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.only(top: 4, right: 4, left: 4),
                          );
                          return;
                        }

                        setState(() {
                          _isSaving = true;
                        });

                        try {
                          // Use controller to create habit
                          await _controller.createHabit(
                            _nameController.text.trim(),
                            int.parse(_selectedCategoryId!),
                          );
                          Navigator.of(context).pop();
                          Get.snackbar(
                            "Success",
                            "Habit added successfully",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.only(top: 4, right: 4, left: 4),
                            icon: Icon(Icons.check_circle, color: Colors.white),
                          );
                        } catch (e) {
                          Get.snackbar(
                            "Error",
                            "Failed to add habit: ${e.toString()}",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.only(top: 4, right: 4, left: 4),
                            icon: Icon(Icons.error, color: Colors.white),
                          );
                        } finally {
                          setState(() {
                            _isSaving = false;
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSaving
                      ? Colors.grey.shade300
                      : Color(0xFF54861C),
                  foregroundColor: _isSaving
                      ? Colors.grey.shade600
                      : Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: _isSaving
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Saving...'),
                        ],
                      )
                    : Text(
                        'Save',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
