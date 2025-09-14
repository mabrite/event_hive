import 'package:flutter/material.dart';
import '../../widgets/user_bottom_nav.dart';

// Import screens
import 'user_home.dart';     // Home class
import 'user_events.dart';
import 'user_feedback.dart';
import 'user_profile.dart';

class UserMain extends StatefulWidget {
  const UserMain({super.key});

  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  int _selectedIndex = 0;

  // Pages for navigation
  late final List<Widget> _pages = [
    const Home(),       // From user_home.dart
    const UserEvents(),
    const UserFeedback(),
    const UserProfile(),
  ];

  // Handle bottom nav tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: UserBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
