import 'dart:ui';
import 'package:flutter/material.dart';
import '../../themes/colors.dart';

class OrganizerEvents extends StatefulWidget {
  const OrganizerEvents({super.key});

  @override
  State<OrganizerEvents> createState() => _OrganizerEventsState();
}

class _OrganizerEventsState extends State<OrganizerEvents> {
  final List<Map<String, String>> _events = [
    {
      'title': 'Tech Summit 2025',
      'date': 'Sept 25, 2025',
      'location': 'Accra Conference Center',
      'registrations': '120'
    },
    {
      'title': 'Developers Meetup',
      'date': 'Oct 10, 2025',
      'location': 'Online',
      'registrations': '85'
    },
    {
      'title': 'Street Carnival',
      'date': 'Oct 10, 2025',
      'location': 'Online',
      'registrations': '85'
    },
    {
      'title': 'StartUp Expo',
      'date': 'Nov 15, 2025',
      'location': 'Takoradi',
      'registrations': '65'
    },
  ];

  void _createEvent() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✨ Create Event tapped!')),
    );
  }

  void _editEvent(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✏️ Edit event: ${_events[index]['title']}')),
    );
  }

  void _deleteEvent(int index) {
    setState(() {
      _events.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🗑️ Event deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Futuristic Events 🚀',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: EventHiveColors.text,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createEvent,
        backgroundColor: EventHiveColors.accent,
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      body: _events.isEmpty
          ? Center(
        child: Text(
          'No events yet.\nTap + to launch your first event!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: EventHiveColors.secondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: EventHiveColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                      EventHiveColors.primary.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: EventHiveColors.primary,
                    child: const Icon(Icons.event,
                        color: Colors.white),
                  ),
                  title: Text(
                    event['title']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: EventHiveColors.text,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${event['date']} • ${event['location']}\n👥 ${event['registrations']} Registrations',
                      style: TextStyle(
                        color: EventHiveColors.secondaryLight,
                        height: 1.4,
                      ),
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) {
                      if (value == 'edit') _editEvent(index);
                      if (value == 'delete') _deleteEvent(index);
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('✏️ Edit'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('🗑️ Delete'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      backgroundColor: EventHiveColors.background,
    );
  }
}
