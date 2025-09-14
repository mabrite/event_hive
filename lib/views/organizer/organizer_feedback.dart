import 'package:flutter/material.dart';
import '../../themes/colors.dart';

class OrganizerFeedback extends StatefulWidget {
  const OrganizerFeedback({super.key});

  @override
  State<OrganizerFeedback> createState() => _OrganizerFeedbackState();
}

class _OrganizerFeedbackState extends State<OrganizerFeedback> {
  final List<Map<String, String>> _feedbackList = [
    {
      'name': 'John Doe',
      'event': 'Tech Summit 2025',
      'message': 'The event was well-organized but started late.',
      'rating': '4'
    },
    {
      'name': 'Mary Smith',
      'event': 'Developers Meetup',
      'message': 'Loved the sessions and networking opportunities!',
      'rating': '5'
    },
    {
      'name': 'Alex Johnson',
      'event': 'StartUp Expo',
      'message': 'Venue was great, but refreshments ran out early.',
      'rating': '3'
    },
  ];

  void _deleteFeedback(int index) {
    setState(() {
      final removed = _feedbackList.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted feedback from ${removed['name']}'),
          backgroundColor: EventHiveColors.accent,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Feedback'),
        backgroundColor: EventHiveColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _feedbackList.isEmpty
          ? Center(
        child: Text(
          'No feedback available yet.',
          style: TextStyle(
            fontSize: 16,
            color: EventHiveColors.secondaryLight,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _feedbackList.length,
        itemBuilder: (context, index) {
          final feedback = _feedbackList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: EventHiveColors.primary,
                child: Text(
                  feedback['name']![0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                feedback['name']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: EventHiveColors.text,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event: ${feedback['event']}',
                    style: TextStyle(color: EventHiveColors.text),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feedback['message']!,
                    style: TextStyle(color: EventHiveColors.text),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                          (starIndex) => Icon(
                        starIndex < int.parse(feedback['rating']!)
                            ? Icons.star
                            : Icons.star_border,
                        color: EventHiveColors.accent,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                color: EventHiveColors.accent,
                tooltip: 'Delete Feedback',
                onPressed: () => _deleteFeedback(index),
              ),
            ),
          );
        },
      ),
      backgroundColor: EventHiveColors.background,
    );
  }
}
