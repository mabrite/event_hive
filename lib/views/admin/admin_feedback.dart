import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../themes/colors.dart';
import '../../widgets/admin_drawer.dart';

class AdminFeedback extends StatefulWidget {
  const AdminFeedback({super.key});

  @override
  State<AdminFeedback> createState() => _AdminFeedbackState();
}

class _AdminFeedbackState extends State<AdminFeedback> {
  String _selectedFilter = 'All';

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
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        title: const Text('Feedback', style: TextStyle(color: Colors.white)),
        backgroundColor: EventHiveColors.primary,
      ),
      drawer: const AdminDrawer(),
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
              'comment': data['comments'] ?? '',
              'rating': (data['rating'] ?? 0).toString(),
              'date': (data['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            };
          }).toList();

          // Apply filter
          List<Map<String, dynamic>> filteredFeedback = allFeedback;
          if (_selectedFilter != 'All') {
            filteredFeedback =
                allFeedback.where((f) => f['rating'] == _selectedFilter).toList();
          }

          return Column(
            children: [
              // Filter chips
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterChip('All'),
                    _buildFilterChip('1'),
                    _buildFilterChip('2'),
                    _buildFilterChip('3'),
                    _buildFilterChip('4'),
                    _buildFilterChip('5'),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredFeedback.length,
                  itemBuilder: (context, index) {
                    final fb = filteredFeedback[index];

                    return FutureBuilder<String>(
                      future: _getUserName(fb['userId']),
                      builder: (context, snapshot) {
                        final userName = snapshot.data ?? "Loading...";

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
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 3,
                            shadowColor: EventHiveColors.secondary.withOpacity(0.2),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: fb['avatar'] != null && fb['avatar'].toString().isNotEmpty
                                    ? NetworkImage(fb['avatar'])
                                    : null,
                                backgroundColor: EventHiveColors.primary,
                                child: (fb['avatar'] == null || fb['avatar'].toString().isEmpty)
                                    ? const Icon(Icons.person, color: Colors.white)
                                    : null,
                              ),
                              title: Text(
                                userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: EventHiveColors.secondary,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fb['comment'],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    fb['date'] is DateTime
                                        ? (fb['date'] as DateTime)
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0]
                                        : fb['date'].toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: List.generate(
                                      5,
                                          (starIndex) => Icon(
                                        starIndex < int.parse(fb['rating'])
                                            ? Icons.star_rounded
                                            : Icons.star_border_rounded,
                                        color: EventHiveColors.accent,
                                        size: 16,
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
                                    onPressed: () => _deleteFeedback(
                                        fb['id'], userName),
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
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: EventHiveColors.primary,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : EventHiveColors.primary,
        fontWeight: FontWeight.w600,
      ),
      side: const BorderSide(color: EventHiveColors.primary),
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
    );
  }
}
