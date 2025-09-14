import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import 'organizer_main.dart';
import 'organizer_events.dart';
import 'organizer_users.dart';
import 'organizer_feedback.dart';
import 'organizer_profile.dart';

class OrganizerDashboard extends StatefulWidget {
  const OrganizerDashboard({super.key});

  @override
  State<OrganizerDashboard> createState() => _OrganizerDashboardState();
}

class _OrganizerDashboardState extends State<OrganizerDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    OrganizerMain(),      // Tab 0 - Home/Main
    OrganizerEvents(),    // Tab 1 - Events
    OrganizerUsers(),     // Tab 2 - Users
    OrganizerFeedback(),  // Tab 3 - Feedback
    OrganizerProfile(),   // Tab 4 - Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: EventHiveColors.primary,   // Updated
        unselectedItemColor: EventHiveColors.secondaryLight, // Updated
        backgroundColor: EventHiveColors.background,  // Optional: makes the nav bar match theme
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Feedback'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
