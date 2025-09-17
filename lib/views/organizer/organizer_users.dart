import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../themes/colors.dart';

class OrganizerUsers extends StatefulWidget {
  const OrganizerUsers({super.key});

  @override
  State<OrganizerUsers> createState() => _OrganizerUsersState();
}

class _OrganizerUsersState extends State<OrganizerUsers> {
  final CollectionReference eventsRef =
  FirebaseFirestore.instance.collection('events');
  final CollectionReference registrationsRef =
  FirebaseFirestore.instance.collection('registrations');

  /// Approve attendee by updating their status in registrations
  Future<void> _approveUser(String registrationId, String name) async {
    await registrationsRef.doc(registrationId).update({'status': 'Confirmed'});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Approved $name')),
    );
  }

  /// Remove attendee by deleting their registration
  Future<void> _removeUser(String registrationId, String name) async {
    await registrationsRef.doc(registrationId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Removed $name')),
    );
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
      body: StreamBuilder<QuerySnapshot>(
        stream: registrationsRef.snapshots(), // 🔥 Real-time updates
        builder: (context, regSnapshot) {
          if (regSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!regSnapshot.hasData || regSnapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No attendees registered yet.',
                style: TextStyle(
                  fontSize: 16,
                  color: EventHiveColors.secondaryLight,
                ),
              ),
            );
          }

          final registrations = regSnapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: registrations.length,
            itemBuilder: (context, index) {
              final regDoc = registrations[index];
              final reg = regDoc.data() as Map<String, dynamic>;

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
                          reg['name'] != null && reg['name'].isNotEmpty
                              ? reg['name'][0]
                              : '?',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        reg['name'] ?? 'Unknown',
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
                            reg['email'] ?? '',
                            style: TextStyle(
                              color: EventHiveColors.secondaryLight,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '🎟 Event: ${reg['eventId']}',
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
                          _buildStatusBadge(reg['status'] ?? 'Pending'),
                          const SizedBox(width: 8),
                          if (reg['status'] == 'Pending')
                            IconButton(
                              icon: const Icon(Icons.check_circle),
                              color: Colors.greenAccent,
                              tooltip: 'Approve',
                              onPressed: () =>
                                  _approveUser(regDoc.id, reg['name']),
                            ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever),
                            color: Colors.redAccent,
                            tooltip: 'Remove',
                            onPressed: () =>
                                _removeUser(regDoc.id, reg['name']),
                          ),
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
    );
  }

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
