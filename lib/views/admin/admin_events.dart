import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../widgets/admin_drawer.dart';

class AdminEvents extends StatefulWidget {
  const AdminEvents({super.key});

  @override
  State<AdminEvents> createState() => _AdminEventsState();
}

class _AdminEventsState extends State<AdminEvents> {
  // Dummy event list (replace with backend / Firebase later)
  final List<Map<String, String>> events = [
    {
      'title': 'Tech Conference 2025',
      'date': '12 Sept 2025',
      'location': 'Accra International Conference Center',
    },
    {
      'title': 'Startup Pitch Night',
      'date': '20 Sept 2025',
      'location': 'GCTU Auditorium',
    },
    {
      'title': 'Flutter Hackathon',
      'date': '5 Oct 2025',
      'location': 'KNUST Campus, Kumasi',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        backgroundColor: EventHiveColors.primary,
        title: const Text(
          'Manage Events',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add Event Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: EventHiveColors.accent,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _showAddEventDialog();
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Event"),
              ),
            ),
            const SizedBox(height: 16),

            // Events List
            Expanded(
              child: events.isEmpty
                  ? Center(
                child: Text(
                  "No events available",
                  style: TextStyle(
                    fontSize: 16,
                    color: EventHiveColors.text.withOpacity(0.7),
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Card(
                    color: Colors.white,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: EventHiveColors.primary,
                        child: const Icon(Icons.event,
                            color: Colors.white),
                      ),
                      title: Text(
                        event['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                          "${event['date']} • ${event['location']}"),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditEventDialog(index);
                          } else if (value == 'delete') {
                            setState(() {
                              events.removeAt(index);
                            });
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to Add Event
  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Event"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Event Title"),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: "Event Date"),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Event Location"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  dateController.text.isNotEmpty &&
                  locationController.text.isNotEmpty) {
                setState(() {
                  events.add({
                    'title': titleController.text,
                    'date': dateController.text,
                    'location': locationController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: EventHiveColors.primary),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // Dialog to Edit Event
  void _showEditEventDialog(int index) {
    final event = events[index];
    final titleController = TextEditingController(text: event['title']);
    final dateController = TextEditingController(text: event['date']);
    final locationController = TextEditingController(text: event['location']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Event"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Event Title"),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: "Event Date"),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Event Location"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  dateController.text.isNotEmpty &&
                  locationController.text.isNotEmpty) {
                setState(() {
                  events[index] = {
                    'title': titleController.text,
                    'date': dateController.text,
                    'location': locationController.text,
                  };
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: EventHiveColors.primary),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
