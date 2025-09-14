import 'package:flutter/material.dart';
import '../../themes/colors.dart';

class OrganizerUsers extends StatefulWidget {
  const OrganizerUsers({super.key});

  @override
  State<OrganizerUsers> createState() => _OrganizerUsersState();
}

class _OrganizerUsersState extends State<OrganizerUsers> {
  // Sample data - later to be fetched from backend
  final List<Map<String, String>> _attendees = [
    {
      'name': 'John Doe',
      'email': 'johndoe@gmail.com',
      'event': 'Tech Summit 2025',
      'status': 'Pending'
    },
    {
      'name': 'Mary Smith',
      'email': 'marysmith@yahoo.com',
      'event': 'Developers Meetup',
      'status': 'Confirmed'
    },
    {
      'name': 'Alex Johnson',
      'email': 'alexj@gmail.com',
      'event': 'StartUp Expo',
      'status': 'Pending'
    },
  ];

  void _approveUser(int index) {
    setState(() {
      _attendees[index]['status'] = 'Confirmed';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Approved ${_attendees[index]['name']}')),
    );
  }

  void _removeUser(int index) {
    setState(() {
      final removed = _attendees.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed ${removed['name']}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        title: const Text('Registered Attendees'),
        backgroundColor: EventHiveColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _attendees.isEmpty
          ? Center(
        child: Text(
          'No attendees registered yet.',
          style: TextStyle(fontSize: 16, color: EventHiveColors.secondary),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _attendees.length,
        itemBuilder: (context, index) {
          final user = _attendees[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: EventHiveColors.primary,
                child: Text(
                  user['name']![0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                user['name']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: EventHiveColors.text,
                ),
              ),
              subtitle: Text(
                '${user['email']}\nEvent: ${user['event']}',
                style: TextStyle(color: EventHiveColors.secondary),
              ),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (user['status'] == 'Pending')
                    IconButton(
                      icon: Icon(Icons.check_circle, color: EventHiveColors.accent),
                      tooltip: 'Approve',
                      onPressed: () => _approveUser(index),
                    ),
                  IconButton(
                    icon: Icon(Icons.delete, color: EventHiveColors.secondary),
                    tooltip: 'Remove',
                    onPressed: () => _removeUser(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
