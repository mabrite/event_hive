import 'package:flutter/material.dart';
import '../../themes/colors.dart';

class OrganizerEvents extends StatefulWidget {
  const OrganizerEvents({super.key});

  @override
  State<OrganizerEvents> createState() => _OrganizerEventsState();
}

class _OrganizerEventsState extends State<OrganizerEvents> {
  // Sample data - later to be fetched from backend
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
      'title': 'StartUp Expo',
      'date': 'Nov 15, 2025',
      'location': 'Takoradi',
      'registrations': '65'
    },
  ];

  void _createEvent() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create Event tapped!')),
    );
  }

  void _editEvent(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit event: ${_events[index]['title']}')),
    );
  }

  void _deleteEvent(int index) {
    setState(() {
      _events.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        backgroundColor: EventHiveColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Event',
            onPressed: _createEvent,
            color: Colors.white,
          )
        ],
      ),
      body: _events.isEmpty
          ? Center(
        child: Text(
          'No events created yet.\nTap + to add your first event.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: EventHiveColors.secondaryLight,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading:
              const Icon(Icons.event, color: EventHiveColors.primary),
              title: Text(
                event['title']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: EventHiveColors.text,
                ),
              ),
              subtitle: Text(
                '${event['date']} • ${event['location']}\nRegistrations: ${event['registrations']}',
                style: TextStyle(color: EventHiveColors.secondaryLight),
              ),
              isThreeLine: true,
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') _editEvent(index);
                  if (value == 'delete') _deleteEvent(index);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: EventHiveColors.background,
    );
  }
}
