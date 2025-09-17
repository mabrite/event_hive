import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../themes/colors.dart';

class OrganizerFeedback extends StatefulWidget {
  const OrganizerFeedback({super.key});

  @override
  State<OrganizerFeedback> createState() => _OrganizerFeedbackState();
}

class _OrganizerFeedbackState extends State<OrganizerFeedback> {
  String _filterType = 'All';

  Future<void> _deleteFeedback(String docId, String name) async {
    await FirebaseFirestore.instance.collection("feedback").doc(docId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted feedback from $name'),
        backgroundColor: EventHiveColors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<String> _getUserName(String userId) async {
    try {
      final userDoc =
      await FirebaseFirestore.instance.collection("users").doc(userId).get();
      return userDoc.data()?['name'] ?? "Anonymous";
    } catch (e) {
      return "Anonymous";
    }
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("feedback")
            .orderBy("submittedAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No feedback available yet.',
                style: TextStyle(
                  fontSize: 16,
                  color: EventHiveColors.secondaryLight,
                ),
              ),
            );
          }

          final allFeedback = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'userId': data['userId'] ?? '',
              'event': data['event'] ?? 'General',
              'message': data['comments'] ?? '',
              'rating': (data['rating'] ?? 0).toString(),
            };
          }).toList();

          // Collect events for dropdown
          final events = allFeedback.map((f) => f['event']!).toSet().toList();

          // Apply filter
          List<Map<String, dynamic>> filteredFeedback = allFeedback;
          if (_filterType != 'All') {
            if (_filterType.startsWith('Rating')) {
              final rating = _filterType.split(' ')[1];
              filteredFeedback =
                  allFeedback.where((f) => f['rating'] == rating).toList();
            } else {
              filteredFeedback =
                  allFeedback.where((f) => f['event'] == _filterType).toList();
            }
          }

          return Column(
            children: [
              // Filter dropdown in body
              Padding(
                padding: const EdgeInsets.only(top: 80, right: 12),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: DropdownButton<String>(
                    value: _filterType,
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.filter_list, color: Colors.black87),
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
                      setState(() => _filterType = value!);
                    },
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [EventHiveColors.background, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: filteredFeedback.isEmpty
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
                    padding:
                    const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    itemCount: filteredFeedback.length,
                    itemBuilder: (context, index) {
                      final feedback = filteredFeedback[index];
                      return FutureBuilder<String>(
                        future: _getUserName(feedback['userId'] ?? ''),
                        builder: (context, snapshot) {
                          final userName =
                              snapshot.data ?? "Loading...";

                          return TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 500),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, value, child) =>
                                Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, (1 - value) * 20),
                                    child: child,
                                  ),
                                ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 6, sigmaY: 6),
                                child: Card(
                                  color:
                                  Colors.white.withOpacity(0.85),
                                  elevation: 6,
                                  shadowColor: EventHiveColors.secondary
                                      .withOpacity(0.3),
                                  margin: const EdgeInsets.only(
                                      bottom: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(16),
                                  ),
                                  child: ListTile(
                                    contentPadding:
                                    const EdgeInsets.all(16),
                                    leading: CircleAvatar(
                                      backgroundColor:
                                      EventHiveColors.primary,
                                      radius: 26,
                                      child: Text(
                                        userName[0],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      userName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: EventHiveColors.text,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 6),
                                        Text(
                                          feedback['event']!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: EventHiveColors
                                                .secondary,
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
                                                  int.parse(feedback[
                                                  'rating'] ??
                                                      '0')
                                                  ? Icons.star_rounded
                                                  : Icons
                                                  .star_border_rounded,
                                              color: EventHiveColors
                                                  .accent,
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
                                        EventHiveColors.accent
                                            .withOpacity(0.15),
                                        child: IconButton(
                                          icon: const Icon(
                                              Icons.delete_forever),
                                          color: EventHiveColors.accent,
                                          onPressed: () =>
                                              _deleteFeedback(
                                                  feedback['id']!,
                                                  userName),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
