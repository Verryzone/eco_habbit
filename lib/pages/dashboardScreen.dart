import 'package:eco_habbit/models/habbit_model.dart';
import 'package:eco_habbit/controllers/dashboard_controller.dart';
import 'package:eco_habbit/widgets/edit_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> 
    with AutomaticKeepAliveClientMixin {
  final DashboardController _controller = DashboardController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          StreamBuilder<bool>(
            stream: _controller.loadingStream,
            initialData: _controller.isLoading,
            builder: (context, loadingSnapshot) {
              final isLoading = loadingSnapshot.data ?? false;
              
              // Show initial loading screen
              if (isLoading && !_controller.isInitialized) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.15),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading habits...',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return StreamBuilder<String?>(
                stream: _controller.errorStream,
                initialData: _controller.error,
                builder: (context, errorSnapshot) {
                  final error = errorSnapshot.data;
                  
                  if (error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: $error'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _controller.refreshData(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return StreamBuilder<List<HabbitModel>>(
                    stream: _controller.habitsStream,
                    initialData: _controller.habits,
                    builder: (context, habitsSnapshot) {
                      final habits = habitsSnapshot.data ?? [];
                      
                      return StreamBuilder<Map<int, String>>(
                        stream: _controller.categoriesStream,
                        initialData: _controller.categoriesMap,
                        builder: (context, categoriesSnapshot) {
                          final categoriesMap = categoriesSnapshot.data ?? {};
                          
                          return RefreshIndicator(
                            onRefresh: () => _controller.refreshData(),
                            color: Colors.green,
                            backgroundColor: Colors.white,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Stack(
                                children: [
                                  ListView.builder(
                                    key: ValueKey(habits.length), // Key berubah saat ada perubahan jumlah
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemCount: habits.length,
                                    itemBuilder: (context, index) {
                                      return TweenAnimationBuilder<double>(
                                        duration: Duration(milliseconds: 300 + (index * 50)), // Staggered animation
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        curve: Curves.easeOutCubic,
                                        builder: (context, value, child) {
                                          return Transform.translate(
                                            offset: Offset((1 - value) * 50, 0), // Reduced slide distance
                                            child: Opacity(
                                              opacity: value,
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 12.0),
                                          child: _buildSlidableCard(context, habits[index], categoriesMap),
                                        ),
                                      );
                                    },
                                  ),
                                  // Subtle loading indicator on top
                                  StreamBuilder<bool>(
                                    stream: _controller.loadingStream,
                                    initialData: _controller.isLoading,
                                    builder: (context, loadingSnapshot) {
                                      final isLoading = loadingSnapshot.data ?? false;
                                      if (isLoading && _controller.isInitialized) {
                                        return Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.9),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      // Try to parse the date string
      DateTime date;
      if (dateString.contains('T')) {
        // If it's in ISO format (with time)
        date = DateTime.parse(dateString);
      } else if (dateString.contains('-')) {
        // If it's in YYYY-MM-DD format
        date = DateTime.parse(dateString);
      } else {
        // If it's just a string, return as is
        return dateString;
      }
      
      // Format to a readable format
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final dateOnly = DateTime(date.year, date.month, date.day);
      
      if (dateOnly == today) {
        return 'Today';
      } else if (dateOnly == yesterday) {
        return 'Yesterday';
      } else {
        // Return in DD MMM YYYY format
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        return '${date.day} ${months[date.month - 1]} ${date.year}';
      }
    } catch (e) {
      // If parsing fails, return original string
      return dateString;
    }
  }

  Widget _buildSlidableCard(BuildContext context, HabbitModel habit, Map<int, String> categoriesMap) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Slidable(
          key: ValueKey(habit.id), // Unique key for each habit
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.4,
            children: [
              SlidableAction(
                onPressed: (context) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => EditHabitModal(habit: habit), 
                  ); // No need for .then() since controller handles updates automatically
                },
                backgroundColor: Colors.amber.shade600,
                foregroundColor: Colors.white,
                icon: Icons.edit_rounded,
              ),
                SlidableAction(
                onPressed: (context) async {
                  // Show confirmation dialog
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, 
                               color: Colors.orange, size: 28),
                          SizedBox(width: 10),
                          Text('Delete Habit', 
                               style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      content: Text('Are you sure you want to delete "${habit.name}"?\nThis action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                          ),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  // Only proceed if user confirmed
                  if (confirmed == true) {
                    try {
                      // Check if habit.id is not null
                      if (habit.id == null || habit.id!.isEmpty) {
                        throw Exception('Habit ID is null or empty');
                      }
                      
                      // Use controller to delete habit (removes from UI and backend)
                      await _controller.deleteHabit(habit.id!);
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Habit "${habit.name}" deleted successfully'),
                              ],
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.error, color: Colors.white),
                                SizedBox(width: 8),
                                Expanded(child: Text('Error deleting habit: $e')),
                              ],
                            ),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 3),
                            action: SnackBarAction(
                              label: 'Retry',
                              textColor: Colors.white,
                              onPressed: () => _controller.refreshData(),
                            ),
                          ),
                        );
                      }
                    }
                  }
                },
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                icon: Icons.delete_rounded,
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFC2D9AB),
              border: Border.all(color: Colors.green.withOpacity(0.2), width: 1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        habit.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.category_rounded,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        categoriesMap[habit.categoryId] ?? 'Unknown Category',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(habit.date),
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
