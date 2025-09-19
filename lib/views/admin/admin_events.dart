import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../themes/colors.dart';
import '../../widgets/admin_drawer.dart';

class AdminEvents extends StatefulWidget {
  const AdminEvents({super.key});

  @override
  State<AdminEvents> createState() => _AdminEventsState();
}

class _AdminEventsState extends State<AdminEvents> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference eventsRef =
  FirebaseFirestore.instance.collection('events');

  bool _isLoading = false;

  final _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      _showEventDialog();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Event"),
                  ),
                ),
                const SizedBox(height: 16),

                // Events List
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: eventsRef.orderBy("timestamp").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            "No events available",
                            style: TextStyle(
                              fontSize: 16,
                              color: EventHiveColors.text.withOpacity(0.7),
                            ),
                          ),
                        );
                      }

                      final events = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final doc = events[index];
                          final event =
                          doc.data() as Map<String, dynamic>;

                          final dateString = event['timestamp'] != null
                              ? (event['timestamp'] as Timestamp)
                              .toDate()
                              .toLocal()
                              .toString()
                              .split(" ")[0]
                              : '';

                          return Card(
                            color: Colors.white,
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: event['image'] != null &&
                                  event['image'].isNotEmpty
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  event['image'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : CircleAvatar(
                                backgroundColor: EventHiveColors.primary,
                                child: const Icon(Icons.event,
                                    color: Colors.white),
                              ),
                              title: Text(
                                event['title'] ?? "Untitled Event",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "$dateString • ${event['location'] ?? "Unknown"}",
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEventDialog(
                                        docId: doc.id, event: event);
                                  } else if (value == 'delete') {
                                    _deleteEvent(doc.id);
                                  }
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        if (_isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Future<void> _showEventDialog({String? docId, Map<String, dynamic>? event}) async {
    final titleController = TextEditingController(text: event?['title'] ?? '');
    final locationController = TextEditingController(text: event?['location'] ?? '');
    final fullLocationController = TextEditingController(text: event?['fullLocation'] ?? '');
    final descriptionController = TextEditingController(text: event?['description'] ?? '');

    DateTime? selectedDate = event?['timestamp'] != null
        ? (event!['timestamp'] as Timestamp).toDate()
        : null;

    File? pickedImageFile;
    String? imageUrl = event?['image'];

    String? selectedCategory = event?['category'];
    final categories = ['sports', 'music', 'food', 'tech', 'education', 'art', 'festive'];

    bool isLoading = false; // ✅ declare here so it persists across rebuilds

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          Future<void> pickDate() async {
            final now = DateTime.now();
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? now,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setDialogState(() {
                selectedDate = picked;
              });
            }
          }

          Future<void> pickImage() async {
            final picker = ImagePicker();
            final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
            if (picked != null) {
              setDialogState(() {
                pickedImageFile = File(picked.path);
              });
            }
          }

          return AlertDialog(
            title: Text(docId == null ? 'Create Event (Admin)' : 'Edit Event (Admin)'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: pickDate,
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: selectedDate != null
                              ? "Date: ${selectedDate!.toLocal().toString().split(" ")[0]}"
                              : "Pick Date",
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                  TextField(
                    controller: fullLocationController,
                    decoration: const InputDecoration(labelText: 'Full Location'),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    hint: const Text('Select Category'),
                    items: categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) => setDialogState(() => selectedCategory = value),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Event Image'),
                  ),
                  if (pickedImageFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Image.file(
                        pickedImageFile!,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  else if (imageUrl != null && imageUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Image.network(
                        imageUrl!,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                  if (selectedDate == null || selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select date and category!')),
                    );
                    return;
                  }

                  setDialogState(() => isLoading = true);

                  // Upload image if picked
                  if (pickedImageFile != null) {
                    final ref = FirebaseStorage.instance
                        .ref()
                        .child('event_images/${DateTime.now().millisecondsSinceEpoch}');
                    await ref.putFile(pickedImageFile!);
                    imageUrl = await ref.getDownloadURL();
                  }

                  const monthNames = [
                    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                  ];
                  String month = monthNames[selectedDate!.month - 1];

                  final data = {
                    'title': titleController.text.trim(),
                    'description': descriptionController.text.trim(),
                    'date': selectedDate!.day.toString(),
                    'month': month,
                    'year': selectedDate!.year.toString(),
                    'location': locationController.text.trim(),
                    'fullLocation': fullLocationController.text.trim(),
                    'category': selectedCategory,
                    'image': imageUrl ?? '',
                    'registrations': event?['registrations'] ?? 0,
                    'attendees': event?['attendees'] ?? [],
                    'userId': FirebaseAuth.instance.currentUser?.uid,
                    'timestamp': selectedDate,
                    'updatedAt': FieldValue.serverTimestamp(),
                    'createdAt': event?['createdAt'] ?? FieldValue.serverTimestamp(),
                  };

                  if (docId == null) {
                    final newDoc = await eventsRef.add(data);

                    await _firestore.collection('notifications').add({
                      'title': "New Event: ${titleController.text.trim()}",
                      'message':
                      "${titleController.text.trim()} is happening at ${locationController.text.trim()}",
                      'time': FieldValue.serverTimestamp(),
                      'type': 'event',
                      'isRead': false,
                      'priority': 'high',
                      'eventId': newDoc.id,
                      'userId': FirebaseAuth.instance.currentUser?.uid,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✨ Event created & notification sent!')),
                    );
                  } else {
                    await eventsRef.doc(docId).update(data);

                    await _firestore.collection('notifications').add({
                      'title': "Updated Event: ${titleController.text.trim()}",
                      'message': "Details of ${titleController.text.trim()} were updated",
                      'time': FieldValue.serverTimestamp(),
                      'type': 'event',
                      'isRead': false,
                      'priority': 'medium',
                      'eventId': docId,
                      'userId': FirebaseAuth.instance.currentUser?.uid,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✏️ Event updated & notification sent!')),
                    );
                  }

                  setDialogState(() => isLoading = false);
                  Navigator.pop(context);
                },
                child: isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text(docId == null ? 'Create' : 'Update'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Delete event
  void _deleteEvent(String docId) async {
    setState(() => _isLoading = true);
    await eventsRef.doc(docId).delete();
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🗑️ Event deleted")),
    );
  }
}
