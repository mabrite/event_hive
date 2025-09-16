import 'package:flutter/material.dart';
import '../../themes/colors.dart'; // Assuming colors.dart is in the same directory

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

  final List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      title: 'New Event Nearby',
      message: 'Tech Conference 2024 is happening 2km away from your location',
      time: '2 min ago',
      type: NotificationType.event,
      isRead: false,
      priority: NotificationPriority.high,
    ),
    NotificationItem(
      id: '2',
      title: 'Friend Request',
      message: 'Sarah Johnson sent you a friend request',
      time: '15 min ago',
      type: NotificationType.social,
      isRead: false,
      priority: NotificationPriority.medium,
    ),
    NotificationItem(
      id: '3',
      title: 'Event Reminder',
      message: 'Your "Music Festival" event starts in 1 hour',
      time: '45 min ago',
      type: NotificationType.reminder,
      isRead: true,
      priority: NotificationPriority.high,
    ),
    NotificationItem(
      id: '4',
      title: 'Location Update',
      message: 'You have new events available in your area',
      time: '2 hours ago',
      type: NotificationType.location,
      isRead: true,
      priority: NotificationPriority.low,
    ),
    NotificationItem(
      id: '5',
      title: 'Weekly Summary',
      message: 'You attended 3 events this week. Check out similar events!',
      time: '1 day ago',
      type: NotificationType.system,
      isRead: false,
      priority: NotificationPriority.medium,
    ),
    NotificationItem(
      id: '6',
      title: 'Event Cancelled',
      message: 'Unfortunately, "Art Workshop" has been cancelled by the organizer',
      time: '2 days ago',
      type: NotificationType.event,
      isRead: true,
      priority: NotificationPriority.medium,
    ),
    NotificationItem(
      id: '7',
      title: 'New Message',
      message: 'John: "Hey, are you going to the concert tonight?"',
      time: '3 days ago',
      type: NotificationType.message,
      isRead: true,
      priority: NotificationPriority.medium,
    ),
    NotificationItem(
      id: '8',
      title: 'App Update Available',
      message: 'Version 2.1.0 is now available with exciting new features',
      time: '1 week ago',
      type: NotificationType.system,
      isRead: true,
      priority: NotificationPriority.low,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _headerScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.elasticOut,
    ));

    // Start animations
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

  List<NotificationItem> get filteredNotifications {
    var filtered = notifications.where((notification) {
      if (_showUnreadOnly && notification.isRead) return false;
      if (_selectedFilter == 'All') return true;
      return notification.type.toString().split('.').last.toLowerCase() ==
          _selectedFilter.toLowerCase();
    }).toList();

    // Sort by priority and time
    filtered.sort((a, b) {
      if (a.priority != b.priority) {
        return b.priority.index.compareTo(a.priority.index);
      }
      return a.time.compareTo(b.time);
    });

    return filtered;
  }

  void _markAsRead(String id) {
    setState(() {
      final notification = notifications.firstWhere((n) => n.id == id);
      notification.isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      notifications.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: EventHiveColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            ScaleTransition(
              scale: _headerScaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildHeader(unreadCount),
              ),
            ),

            // Filter Section
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildFilterSection(),
            ),

            // Notifications List
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildNotificationsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int unreadCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row
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
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: EventHiveColors.primary,
                    size: 20,
                  ),
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
                  onTap: _markAllAsRead,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
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

          // Stats Row
          Row(
            children: [
              _buildStatCard(
                'Total',
                notifications.length.toString(),
                Icons.notifications,
                EventHiveColors.primary,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Unread',
                unreadCount.toString(),
                Icons.notifications_active,
                EventHiveColors.accent,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Today',
                notifications.where((n) =>
                n.time.contains('min ago') || n.time.contains('hour')).length.toString(),
                Icons.today,
                EventHiveColors.secondary,
              ),
            ],
          ),
        ],
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
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: EventHiveColors.text.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    final filters = ['All', 'Event', 'Social', 'Message', 'System'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: Colors.white,
      child: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) => setState(() => _selectedFilter = filter),
                    selectedColor: EventHiveColors.primary,
                    backgroundColor: EventHiveColors.background,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : EventHiveColors.text,
                    ),
                    checkmarkColor: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Unread Only Toggle
          Row(
            children: [
              Switch(
                value: _showUnreadOnly,
                onChanged: (value) => setState(() => _showUnreadOnly = value),
                activeColor: EventHiveColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Show unread only',
                style: TextStyle(
                  color: EventHiveColors.text,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    final filtered = filteredNotifications;

    if (filtered.isEmpty) {
      return Container(
        color: EventHiveColors.background,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_off,
                size: 80,
                color: EventHiveColors.secondary.withOpacity(0.4),
              ),
              const SizedBox(height: 16),
              Text(
                'No notifications found',
                style: TextStyle(
                  color: EventHiveColors.text.withOpacity(0.6),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your filters',
                style: TextStyle(
                  color: EventHiveColors.text.withOpacity(0.4),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: EventHiveColors.background,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          return _buildNotificationCard(filtered[index], index);
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, int index) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _deleteNotification(notification.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 24,
        ),
      ),
      child: GestureDetector(
        onTap: () => _markAsRead(notification.id),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: notification.isRead
                  ? Colors.transparent
                  : _getNotificationColor(notification.type).withOpacity(0.3),
              width: notification.isRead ? 0 : 2,
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              color: EventHiveColors.text,
                              fontSize: 16,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getNotificationColor(notification.type),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        color: EventHiveColors.text.withOpacity(0.7),
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: EventHiveColors.text.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          notification.time,
                          style: TextStyle(
                            color: EventHiveColors.text.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        _buildPriorityBadge(notification.priority),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(NotificationPriority priority) {
    Color color;
    String text;

    switch (priority) {
      case NotificationPriority.high:
        color = Colors.red;
        text = 'High';
        break;
      case NotificationPriority.medium:
        color = Colors.orange;
        text = 'Medium';
        break;
      case NotificationPriority.low:
        color = EventHiveColors.secondary;
        text = 'Low';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.event:
        return EventHiveColors.primary;
      case NotificationType.social:
        return EventHiveColors.accent;
      case NotificationType.message:
        return EventHiveColors.primaryLight;
      case NotificationType.reminder:
        return Colors.amber;
      case NotificationType.location:
        return EventHiveColors.secondaryLight;
      case NotificationType.system:
        return EventHiveColors.secondary;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.event:
        return Icons.event;
      case NotificationType.social:
        return Icons.people;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.location:
        return Icons.location_on;
      case NotificationType.system:
        return Icons.settings;
    }
  }
}

// Data Models
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  bool isRead;
  final NotificationPriority priority;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
    required this.priority,
  });
}

enum NotificationType {
  event,
  social,
  message,
  reminder,
  location,
  system,
}

enum NotificationPriority {
  low,
  medium,
  high,
}