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
      appBar: AppBar(
        title: const Text('Organizer Overview'),
        centerTitle: true,
        backgroundColor: EventHiveColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: EventHiveColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back, Organizer!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: EventHiveColors.text,
              ),
            ),
            const SizedBox(height: 12),

            // Quick Stats Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Events', '12', Icons.event),
                _buildStatCard('Registrations', '245', Icons.people),
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
            const SizedBox(height: 8),
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
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
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

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon, size: 30, color: EventHiveColors.primary),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
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
    );
  }

  Widget _buildUpcomingEventCard({required String title, required String date, required String location}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.event, color: EventHiveColors.primary),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: EventHiveColors.text),
        ),
        subtitle: Text(
          '$date • $location',
          style: TextStyle(color: EventHiveColors.text),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: EventHiveColors.secondary),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: EventHiveColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: EventHiveColors.primary),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: EventHiveColors.text),
            ),
          ],
        ),
      ),
    );
  }
}
