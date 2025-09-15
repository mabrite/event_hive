import 'dart:ui';
import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import 'organizer_events.dart';
import 'organizer_users.dart';
import 'organizer_feedback.dart';

class OrganizerMain extends StatelessWidget {
  const OrganizerMain({super.key});

  @override
  Widget build(BuildContext context) {
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

            // Quick Stats Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Events', '12', Icons.event),
                const SizedBox(width: 12),
                _buildStatCard('Registrations', '245', Icons.people),
                const SizedBox(width: 12),
                _buildStatCard('Feedback', '34', Icons.feedback),
              ],
            ),
            const SizedBox(height: 24),

            // Upcoming Events Preview
            Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: EventHiveColors.text,
              ),
            ),
            const SizedBox(height: 12),
            _buildUpcomingEventCard(
              title: 'Tech Summit 2025',
              date: 'Sept 25, 2025',
              location: 'Accra Conference Center',
            ),
            _buildUpcomingEventCard(
              title: 'Developers Meetup',
              date: 'Oct 10, 2025',
              location: 'Online',
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
                  label: 'Manage Users',
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

  // Futuristic Stat Card
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

  // Futuristic Upcoming Event Card
  Widget _buildUpcomingEventCard(
      {required String title, required String date, required String location}) {
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

  // Futuristic Quick Action Button
  Widget _buildActionButton(
      {required IconData icon,
        required String label,
        required VoidCallback onTap}) {
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
