import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import '../../themes/colors.dart'; // ✅ Import EventHiveColors

class UserBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const UserBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      selectedIndex: currentIndex,
      onItemSelected: onTap,
      backgroundColor: EventHiveColors.background,
      containerHeight: 60,
      curve: Curves.easeInOut,
      items: [
        BottomNavyBarItem(
          icon: const Icon(Icons.home),
          title: const Text('Home'),
          activeColor: EventHiveColors.primary,
          inactiveColor: EventHiveColors.secondary.withOpacity(0.6),
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.event),
          title: const Text('Events'),
          activeColor: EventHiveColors.primary,
          inactiveColor: EventHiveColors.secondary.withOpacity(0.6),
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.feedback),
          title: const Text('Feedback'),
          activeColor: EventHiveColors.primary,
          inactiveColor: EventHiveColors.secondary.withOpacity(0.6),
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.person),
          title: const Text('Profile'),
          activeColor: EventHiveColors.primary,
          inactiveColor: EventHiveColors.secondary.withOpacity(0.6),
        ),
      ],
    );
  }
}
