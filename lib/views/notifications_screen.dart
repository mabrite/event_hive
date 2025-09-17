import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../themes/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _staggerController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _headerScaleAnimation;

  bool _showUnreadOnly = false;
  String _selectedFilter = 'All';

  String get _userId => FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();

    _slideController =
        AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _fadeController =
        AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _staggerController =
        AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _headerScaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.elasticOut),
    );

    _slideController.forward();
    _fadeController.forward();
    _staggerController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> getNotifications() {
    return FirebaseFirestore.instance
        .collection('notifications') // <-- global collection
        .orderBy('time', descending: true)
        .snapshots();
  }

  void _markAsRead(String id) {
    FirebaseFirestore.instance
        .collection('notifications') // <-- global collection
        .doc(id)
        .update({'isRead': true});
  }

  void _markAllAsRead(List<DocumentSnapshot> docs) {
    for (var doc in docs) {
      doc.reference.update({'isRead': true});
    }
  }

  void _deleteNotification(String id) {
    FirebaseFirestore.instance
        .collection('notifications') // <-- global collection
        .doc(id)
        .delete();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: getNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data?.docs ?? [];

            // Filter notifications
            final filtered = docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final isRead = data['isRead'] ?? false;
              final type = data['type'] ?? 'system';

              if (_showUnreadOnly && isRead) return false;
              if (_selectedFilter == 'All') return true;
              return type.toString().toLowerCase() == _selectedFilter.toLowerCase();
            }).toList();

            final unreadCount =
                docs.where((doc) => !(doc['isRead'] as bool? ?? true)).length;

            return Column(
              children: [
                // Header
                ScaleTransition(
                  scale: _headerScaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildHeader(unreadCount, docs),
                  ),
                ),

                // Filters
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildFilterSection(),
                ),

                // Notifications
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildNotificationsList(filtered),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(int unreadCount, List<DocumentSnapshot> docs) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: EventHiveColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.arrow_back_ios,
                      color: EventHiveColors.primary, size: 20),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    color: EventHiveColors.text,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (unreadCount > 0)
                GestureDetector(
                  onTap: () => _markAllAsRead(docs),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: EventHiveColors.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Mark All Read',
                      style: TextStyle(
                        color: EventHiveColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats
          Row(
            children: [
              _buildStatCard('Total', docs.length.toString(),
                  Icons.notifications, EventHiveColors.primary),
              const SizedBox(width: 16),
              _buildStatCard('Unread', unreadCount.toString(),
                  Icons.notifications_active, EventHiveColors.accent),
              const SizedBox(width: 16),
              _buildStatCard(
                  'Today',
                  docs
                      .where((d) {
                    final ts = d['time'];
                    if (ts is Timestamp) {
                      final date = ts.toDate();
                      return date.day == DateTime.now().day &&
                          date.month == DateTime.now().month &&
                          date.year == DateTime.now().year;
                    }
                    return false;
                  })
                      .length
                      .toString(),
                  Icons.today,
                  EventHiveColors.secondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<DocumentSnapshot> filtered) {
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.notifications_off, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text("No notifications found"),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final doc = filtered[index];
        final data = doc.data() as Map<String, dynamic>;

        return Dismissible(
          key: Key(doc.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => _deleteNotification(doc.id),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete, color: Colors.white, size: 24),
          ),
          child: GestureDetector(
            onTap: () => _markAsRead(doc.id),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1), blurRadius: 4)
                ],
                border: Border.all(
                  color: (data['isRead'] ?? false)
                      ? Colors.transparent
                      : EventHiveColors.primary.withOpacity(0.3),
                  width: (data['isRead'] ?? false) ? 0 : 2,
                ),
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: EventHiveColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.notifications,
                        color: EventHiveColors.primary, size: 24),
                  ),
                  const SizedBox(width: 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['title'] ?? 'No title',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(data['message'] ?? '',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 14)),
                        const SizedBox(height: 8),
                        Text(
                          (data['time'] as Timestamp?)?.toDate().toString() ??
                              '',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSection() {
    final filters = ['All', 'Event', 'Social', 'Message', 'System'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedFilter = filter),
                selectedColor: EventHiveColors.primary,
                backgroundColor: EventHiveColors.background,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : EventHiveColors.text,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    color: color, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label,
                style: TextStyle(
                    color: EventHiveColors.text.withOpacity(0.7), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
