import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class UserBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const UserBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  // Consistent colors (from login screen)
  static const Color primary = Color(0xFF1A237E);    // Deep Indigo (login primary)
  static const Color secondary = Color(0xFF5669FF);  // Amber (login secondary)
  static const Color background = Color(0xFFFFFFFF); // White (login background)

  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      selectedIndex: currentIndex,
      onItemSelected: onTap,
      backgroundColor: background,
      containerHeight: 60,
      curve: Curves.easeInOut,
      items: [
        BottomNavyBarItem(
          icon: const Icon(Icons.home),
          title: const Text('Home'),
          activeColor: primary,
          inactiveColor: secondary.withOpacity(0.6),
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.event),
          title: const Text('Events'),
          activeColor: primary,
          inactiveColor: secondary.withOpacity(0.6),
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.feedback),
          title: const Text('Feedback'),
          activeColor: primary,
          inactiveColor: secondary.withOpacity(0.6),
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.person),
          title: const Text('Profile'),
          activeColor: primary,
          inactiveColor: secondary.withOpacity(0.6),
        ),
      ],
    );
  }
}
