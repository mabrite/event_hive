import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../themes/colors.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class OrganizerEvents extends StatefulWidget {
  const OrganizerEvents({super.key});

  @override
  State<OrganizerEvents> createState() => _OrganizerEventsState();
}

class _OrganizerEventsState extends State<OrganizerEvents> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get eventsRef => _firestore.collection('events');
  String? get currentUserId => _auth.currentUser?.uid;

  bool _isLoading = false;

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
            title: Text(docId == null ? 'Create Event' : 'Edit Event'),
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
                onPressed: () async {
                  if (selectedDate == null || selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select date and category!')),
                    );
                    return;
                  }

                  setState(() => _isLoading = true);

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
                    'userId': currentUserId,
                    'timestamp': selectedDate,
                    'updatedAt': FieldValue.serverTimestamp(),
                    'createdAt': event?['createdAt'] ?? FieldValue.serverTimestamp(),
                  };

                  if (docId == null) {
                    // Create new event
                    final newDoc = await eventsRef.add(data);

                    // Add dynamic notification
                    await _firestore.collection('notifications').add({
                      'title': "New Event: ${titleController.text.trim()}",
                      'message':
                      "${titleController.text.trim()} is happening at ${locationController.text.trim()}",
                      'time': FieldValue.serverTimestamp(),
                      'type': 'event',
                      'isRead': false,
                      'priority': 'high',
                      'eventId': newDoc.id,
                      'userId': currentUserId,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✨ Event created & notification sent!')),
                    );
                  } else {
                    // Update existing event
                    await eventsRef.doc(docId).update(data);

                    // Add/update notification
                    await _firestore.collection('notifications').add({
                      'title': "Updated Event: ${titleController.text.trim()}",
                      'message': "Details of ${titleController.text.trim()} were updated",
                      'time': FieldValue.serverTimestamp(),
                      'type': 'event',
                      'isRead': false,
                      'priority': 'medium',
                      'eventId': docId,
                      'userId': currentUserId,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✏️ Event updated & notification sent!')),
                    );
                  }

                  setState(() => _isLoading = false);
                  Navigator.pop(context);
                },
                child: Text(docId == null ? 'Create' : 'Update'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteEvent(String docId) async {
    setState(() => _isLoading = true);
    await eventsRef.doc(docId).delete();
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🗑️ Event deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return const Center(child: Text('User not logged in'));
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('My Events 🚀', style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: EventHiveColors.text,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showEventDialog(),
            backgroundColor: EventHiveColors.accent,
            child: const Icon(Icons.add, size: 30, color: Colors.white),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: eventsRef
                .where('userId', isEqualTo: currentUserId)
                .orderBy('timestamp')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No events yet.\nTap + to create your first event!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: EventHiveColors.secondaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              final events = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final doc = events[index];
                  final event = doc.data() as Map<String, dynamic>;

                  final dateString = event['timestamp'] != null
                      ? (event['timestamp'] as Timestamp).toDate().toLocal().toString().split(' ')[0]
                      : '';

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
                              color: EventHiveColors.primary.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: ListTile(
                          leading: event['image'] != null && event['image'].isNotEmpty
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
                            child: const Icon(Icons.event, color: Colors.white),
                          ),
                          title: Text(
                            event['title'] ?? 'Untitled Event',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: EventHiveColors.text,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              '$dateString • ${event['location'] ?? 'Unknown'}\n👥 ${event['registrations'] ?? 0} Registrations\n📝 ${event['description'] ?? ''}',
                              style: TextStyle(
                                color: EventHiveColors.secondaryLight,
                                height: 1.4,
                              ),
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEventDialog(docId: doc.id, event: event);
                              } else if (value == 'delete') {
                                _deleteEvent(doc.id);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: 'edit', child: Text('✏️ Edit')),
                              PopupMenuItem(value: 'delete', child: Text('🗑️ Delete')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          backgroundColor: EventHiveColors.background,
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
}