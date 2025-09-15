import 'dart:ui';
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

  String _filterType = 'All';

  void _deleteFeedback(int index) {
    setState(() {
      final removed = _feedbackList.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted feedback from ${removed['name']}'),
          backgroundColor: EventHiveColors.accent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    });
  }

  List<Map<String, String>> get _filteredFeedback {
    if (_filterType == 'All') return _feedbackList;

    if (_filterType.startsWith('Rating')) {
      final rating = _filterType.split(' ')[1];
      return _feedbackList.where((f) => f['rating'] == rating).toList();
    }

    return _feedbackList.where((f) => f['event'] == _filterType).toList();
  }

  @override
  Widget build(BuildContext context) {
    final events = _feedbackList.map((f) => f['event']!).toSet().toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Event Feedback"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [EventHiveColors.primary, EventHiveColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButton<String>(
              value: _filterType,
              dropdownColor: Colors.white,
              icon: const Icon(Icons.filter_list, color: Colors.white),
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem(
                  value: 'All',
                  child: Text('All'),
                ),
                ...events.map((e) => DropdownMenuItem(
                  value: e,
                  child: Text('Event: $e'),
                )),
                ...List.generate(
                  5,
                      (i) => DropdownMenuItem(
                    value: 'Rating ${i + 1}',
                    child: Text('Rating: ${i + 1} stars'),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _filterType = value!;
                });
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [EventHiveColors.background, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _filteredFeedback.isEmpty
            ? Center(
          child: Text(
            'No feedback available for this filter.',
            style: TextStyle(
              fontSize: 16,
              color: EventHiveColors.secondaryLight,
            ),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
          itemCount: _filteredFeedback.length,
          itemBuilder: (context, index) {
            final feedback = _filteredFeedback[index];
            return TweenAnimationBuilder(
              duration: const Duration(milliseconds: 500),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 20),
                  child: child,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Card(
                    color: Colors.white.withOpacity(0.85),
                    elevation: 6,
                    shadowColor: EventHiveColors.secondary.withOpacity(0.3),
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: EventHiveColors.primary,
                        radius: 26,
                        child: Text(
                          feedback['name']![0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        feedback['name']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: EventHiveColors.text,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                            feedback['event']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: EventHiveColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            feedback['message']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: EventHiveColors.text,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: List.generate(
                              5,
                                  (starIndex) => Icon(
                                starIndex <
                                    int.parse(feedback['rating'] ?? '0')
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: EventHiveColors.accent,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Tooltip(
                        message: 'Delete Feedback',
                        child: CircleAvatar(
                          backgroundColor:
                          EventHiveColors.accent.withOpacity(0.15),
                          child: IconButton(
                            icon: const Icon(Icons.delete_forever),
                            color: EventHiveColors.accent,
                            onPressed: () => _deleteFeedback(index),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
