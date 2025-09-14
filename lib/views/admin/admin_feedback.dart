import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../widgets/admin_drawer.dart';

class AdminFeedback extends StatefulWidget {
  const AdminFeedback({super.key});

  @override
  State<AdminFeedback> createState() => _AdminFeedbackState();
}

class _AdminFeedbackState extends State<AdminFeedback> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _feedback = [
    {
      'name': 'Alice Johnson',
      'avatar': 'https://i.pravatar.cc/150?img=4',
      'rating': 'Positive',
      'comment': 'Loved the new update! The UI feels much smoother.',
      'date': '2025-08-10',
      'resolved': false
    },
    {
      'name': 'David Smith',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'rating': 'Negative',
      'comment': 'App crashes when opening settings.',
      'date': '2025-08-09',
      'resolved': false
    },
    {
      'name': 'Sophia Lee',
      'avatar': 'https://i.pravatar.cc/150?img=6',
      'rating': 'Pending',
      'comment': 'Feature request: dark mode toggle in quick menu.',
      'date': '2025-08-08',
      'resolved': false
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFeedback = _feedback.where((f) {
      if (_selectedFilter == 'All') return true;
      return f['rating'] == _selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        title: const Text(
          'Feedback',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: EventHiveColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AdminDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 12),

          // Stats cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Total', _feedback.length, EventHiveColors.primary),
                _buildStatCard(
                  'Positive',
                  _feedback.where((f) => f['rating'] == 'Positive').length,
                  Colors.green.shade600,
                ),
                _buildStatCard(
                  'Negative',
                  _feedback.where((f) => f['rating'] == 'Negative').length,
                  Colors.red.shade600,
                ),
                _buildStatCard(
                  'Pending',
                  _feedback.where((f) => f['rating'] == 'Pending').length,
                  EventHiveColors.accent,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Positive'),
                _buildFilterChip('Negative'),
                _buildFilterChip('Pending'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Feedback list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredFeedback.length,
              itemBuilder: (context, index) {
                final fb = filteredFeedback[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 3,
                  shadowColor: EventHiveColors.secondary.withOpacity(0.2),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(fb['avatar']),
                    ),
                    title: Text(
                      fb['name'],
                      style: TextStyle(
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
                          fb['date'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          fb['rating'] == 'Positive'
                              ? Icons.thumb_up
                              : fb['rating'] == 'Negative'
                              ? Icons.thumb_down
                              : Icons.hourglass_top,
                          color: fb['rating'] == 'Positive'
                              ? Colors.green.shade600
                              : fb['rating'] == 'Negative'
                              ? Colors.red.shade600
                              : EventHiveColors.accent,
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () {
                            setState(() {
                              fb['resolved'] = !fb['resolved'];
                            });
                          },
                          child: Text(
                            fb['resolved'] ? 'Resolved' : 'Resolve',
                            style: TextStyle(
                              fontSize: 12,
                              color: fb['resolved']
                                  ? Colors.grey
                                  : EventHiveColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Container(
      width: 75,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color),
          ),
        ],
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
      side: BorderSide(color: EventHiveColors.primary),
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
    );
  }
}
