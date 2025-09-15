import 'dart:ui';
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
      SnackBar(content: Text('✅ Approved ${_attendees[index]['name']}')),
    );
  }

  void _removeUser(int index) {
    setState(() {
      final removed = _attendees.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Removed ${removed['name']}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        title: const Text('👥 Registered Attendees'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: EventHiveColors.text,
      ),
      body: _attendees.isEmpty
          ? Center(
        child: Text(
          'No attendees registered yet.',
          style: TextStyle(
            fontSize: 16,
            color: EventHiveColors.secondaryLight,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _attendees.length,
        itemBuilder: (context, index) {
          final user = _attendees[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: EventHiveColors.primary.withOpacity(0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: EventHiveColors.primary.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: EventHiveColors.primary,
                    child: Text(
                      user['name']![0],
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    user['name']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: EventHiveColors.text,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['email']!,
                        style: TextStyle(
                          color: EventHiveColors.secondaryLight,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '🎟 ${user['event']}',
                        style: TextStyle(
                          color: EventHiveColors.secondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStatusBadge(user['status']!),
                      const SizedBox(width: 8),
                      if (user['status'] == 'Pending')
                        IconButton(
                          icon: const Icon(Icons.check_circle),
                          color: Colors.greenAccent,
                          tooltip: 'Approve',
                          onPressed: () => _approveUser(index),
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete_forever),
                        color: Colors.redAccent,
                        tooltip: 'Remove',
                        onPressed: () => _removeUser(index),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Modern status badge
  Widget _buildStatusBadge(String status) {
    final bool isConfirmed = status == 'Confirmed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isConfirmed
            ? Colors.green.withOpacity(0.2)
            : Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConfirmed ? Colors.green : Colors.amber,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isConfirmed ? Colors.green : Colors.amber[800],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
