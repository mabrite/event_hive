// login_activity_screen.dart
import 'package:flutter/material.dart';
import '../../themes/colors.dart'; // <-- Import your EventHiveColors

class LoginActivityScreen extends StatelessWidget {
  const LoginActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'device': 'Chrome on Windows',
        'location': 'Accra, Ghana',
        'time': 'Today, 2:45 PM'
      },
      {
        'device': 'Mobile Safari',
        'location': 'Kumasi, Ghana',
        'time': 'Yesterday, 9:20 AM'
      },
      {
        'device': 'Firefox on Mac',
        'location': 'New York, USA',
        'time': 'Apr 20, 11:05 AM'
      },
    ];

    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: EventHiveColors.secondary,
        title: const Text(
          'Login Activity',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: EventHiveColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Logins',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: EventHiveColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: activities.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final item = activities[index];
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: EventHiveColors.secondary.withOpacity(0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: EventHiveColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.devices,
                            color: EventHiveColors.primary,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['device']!,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: EventHiveColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['location']!,
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                  EventHiveColors.secondary.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          item['time']!,
                          style: TextStyle(
                            fontSize: 13,
                            color:
                            EventHiveColors.secondary.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to full history
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: EventHiveColors.primary.withOpacity(0.1),
                ),
                child: Text(
                  'See More',
                  style: TextStyle(
                    color: EventHiveColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
