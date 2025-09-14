// organizer_drawer.dart - Organizer Navigation Drawer

import 'package:flutter/material.dart';
import '../../themes/colors.dart'; // import EventHiveColors

class OrganizerDrawer extends StatelessWidget {
  const OrganizerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(color: EventHiveColors.primary),
            child: Text(
              'Organizer Menu',
              style: TextStyle(
                color: EventHiveColors.background,
                fontSize: 20,
              ),
            ),
          ),
          ListTile(title: Text('Dashboard', style: TextStyle(color: EventHiveColors.text))),
          ListTile(title: Text('Events', style: TextStyle(color: EventHiveColors.text))),
          ListTile(title: Text('Profile', style: TextStyle(color: EventHiveColors.text))),
          ListTile(title: Text('Feedback', style: TextStyle(color: EventHiveColors.text))),
          ListTile(title: Text('Users', style: TextStyle(color: EventHiveColors.text))),
        ],
      ),
    );
  }
}
