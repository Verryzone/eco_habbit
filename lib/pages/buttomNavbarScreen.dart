import 'package:eco_habbit/pages/analyticScreen.dart';
import 'package:eco_habbit/pages/dashboardScreen.dart';
import 'package:eco_habbit/pages/profileScreen.dart';
import 'package:eco_habbit/widgets/add_modal.dart';
import 'package:flutter/material.dart';

class ButtonNavbarScreen extends StatefulWidget {
  const ButtonNavbarScreen({super.key});

  @override
  State<ButtonNavbarScreen> createState() => _ButtonNavbarScreenState();
}

// class _ButtonNavbarScreenState extends State<ButtonNavbarScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: ListView(
//             children: [_buildCard(), const SizedBox(height: 12), _buildCard()],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNavBar(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Add action
//         },
//         backgroundColor: Color(0xFFC2D9AB),
//         child: const Icon(Icons.add, color: Color(0xFF54861C)),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }

//   Widget _buildCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFFC2D9AB),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: const EdgeInsets.all(12),
//       child: const Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Using botle',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//           SizedBox(height: 4),
//           Text(
//             'Reuse',
//             style: TextStyle(color: Color.fromARGB(255, 87, 87, 87)),
//           ),
//           SizedBox(height: 2),
//           Text(
//             '21-May-2025',
//             style: TextStyle(color: Color.fromARGB(255, 87, 87, 87)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNavBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       decoration: const BoxDecoration(
//         color: Color(0xFFF5F6F7),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(Icons.home, isSelected: true),
//           _buildNavItem(Icons.history),
//           _buildNavItem(Icons.person),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData iconData, {bool isSelected = false}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isSelected ? Color(0xFFC2D9AB) : Colors.transparent,
//         shape: BoxShape.circle,
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
//       child: Icon(iconData, color: Color(0xFF54861C)),
//     );
//   }
// }

class _ButtonNavbarScreenState extends State<ButtonNavbarScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(),
    AnalyticScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // AnimatedSwitcher dengan transisi lebih interaktif (combine fade, slide, dan scale)
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            final inAnimation = Tween<Offset>(
              begin: Offset(_selectedIndex == 0 ? 0.2 : -0.2, 0),
              end: Offset.zero,
            ).animate(animation);

            final scaleAnim = Tween<double>(
              begin: 0.95,
              end: 1.0,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: inAnimation,
                child: ScaleTransition(scale: scaleAnim, child: child),
              ),
            );
          },
          child: Container(
            key: ValueKey<int>(_selectedIndex),
            child: _pages[_selectedIndex],
          ),
          layoutBuilder: (currentChild, previousChildren) => currentChild!,
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // Add action
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => const AddHabitModal(),
                );
              },
              backgroundColor: Color(0xFFC2D9AB),
              child: const Icon(Icons.add, color: Color(0xFF54861C)),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.history, 1),
          _buildNavItem(Icons.person, 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData iconData, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFC2D9AB) : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color(0xFF54861C).withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        width: 56,
        height: 56,
        alignment: Alignment.center,
        child: AnimatedScale(
          scale: isSelected ? 1.18 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: Icon(iconData, color: Color(0xFF54861C), size: 30),
        ),
      ),
    );
  }
}
