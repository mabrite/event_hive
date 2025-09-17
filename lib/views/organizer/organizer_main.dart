import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../themes/colors.dart';
import 'organizer_events.dart';
import 'organizer_users.dart';
import 'organizer_feedback.dart';

class OrganizerMain extends StatefulWidget {
  const OrganizerMain({super.key});

  @override
  State<OrganizerMain> createState() => _OrganizerMainState();
}

class _OrganizerMainState extends State<OrganizerMain> {
  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        title: const Text(
          'Organizer Dashboard 🚀',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: EventHiveColors.text,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    EventHiveColors.primary,
                    EventHiveColors.accent.withOpacity(0.8)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: EventHiveColors.primary.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Text(
                '✨ Welcome Back, Organizer!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Real-time Quick Stats
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("events")
                  .where("userId", isEqualTo: userId)
                  .snapshots(),
              builder: (context, eventSnap) {
                if (!eventSnap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final events = eventSnap.data!.docs;
                final eventIds = events.map((doc) => doc.id).toList();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard('Events', events.length.toString(), Icons.event),
                    const SizedBox(width: 12),
                    // Registrations Stream
                    StreamBuilder<QuerySnapshot>(
                      stream: eventIds.isEmpty
                          ? const Stream.empty()
                          : FirebaseFirestore.instance
                          .collection("registrations")
                          .where("eventId", whereIn: eventIds)
                          .snapshots(),
                      builder: (context, regSnap) {
                        final count = regSnap.hasData ? regSnap.data!.docs.length : 0;
                        return _buildStatCard('Registrations', count.toString(), Icons.people);
                      },
                    ),
                    const SizedBox(width: 12),
                    // Feedback Stream
                    StreamBuilder<QuerySnapshot>(
                      stream: eventIds.isEmpty
                          ? const Stream.empty()
                          : FirebaseFirestore.instance
                          .collection("feedback")
                          .where("eventId", whereIn: eventIds)
                          .snapshots(),
                      builder: (context, fbSnap) {
                        final count = fbSnap.hasData ? fbSnap.data!.docs.length : 0;
                        return _buildStatCard('Feedback', count.toString(), Icons.feedback);
                      },
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Upcoming Events (real-time)
            Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: EventHiveColors.text,
              ),
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("events")
                  .where("userId", isEqualTo: userId)
                  .orderBy("timestamp", descending: false)
                  .limit(2)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final events = snapshot.data!.docs;
                if (events.isEmpty) {
                  return Text("No upcoming events",
                      style: TextStyle(color: EventHiveColors.secondaryLight));
                }

                return Column(
                  children: events.take(3).map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return _buildUpcomingEventCard(
                      title: data["title"] ?? "Untitled",
                      date: "${data["month"] ?? ""} ${data["date"] ?? ""}",
                      location: data["fullLocation"] ?? "Unknown",
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: EventHiveColors.text,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _buildActionButton(
                  icon: Icons.add_circle,
                  label: 'Create Event',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrganizerEvents()),
                  ),
                ),
                _buildActionButton(
                  icon: Icons.people,
                  label: 'Manage Registered Attendees',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrganizerUsers()),
                  ),
                ),
                _buildActionButton(
                  icon: Icons.feedback,
                  label: 'View Feedback',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrganizerFeedback()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Stat Card
  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: EventHiveColors.primary.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: EventHiveColors.primary.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(icon, size: 30, color: EventHiveColors.accent),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: EventHiveColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: EventHiveColors.secondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Upcoming Event Card
  Widget _buildUpcomingEventCard({
    required String title,
    required String date,
    required String location,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: EventHiveColors.primary.withOpacity(0.25),
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: EventHiveColors.primary,
              child: const Icon(Icons.event, color: Colors.white),
            ),
            title: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: EventHiveColors.text),
            ),
            subtitle: Text(
              '$date • $location',
              style: TextStyle(color: EventHiveColors.secondaryLight),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                size: 16, color: EventHiveColors.accent),
          ),
        ),
      ),
    );
  }

  // Quick Action Button
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 115,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              EventHiveColors.primary.withOpacity(0.8),
              EventHiveColors.accent.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: EventHiveColors.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
