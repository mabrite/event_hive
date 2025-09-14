import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../widgets/admin_drawer.dart';
import '../../themes/colors.dart'; // Import your global palette

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotateController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: _buildModernAppBar(),
      drawer: const AdminDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [EventHiveColors.background, EventHiveColors.secondaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 20),
              _buildAnalyticsGrid(),
              const SizedBox(height: 20),
              _buildQuickActionsRow(),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildRecentActivity()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildPerformanceChart()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Modern AppBar
  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      backgroundColor: EventHiveColors.primary.withOpacity(0.8),
      elevation: 0,
      title: Row(
        children: [
          AnimatedBuilder(
            animation: _rotateAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotateAnimation.value,
                child: const Icon(Icons.dashboard, color: EventHiveColors.accent),
              );
            },
          ),
          const SizedBox(width: 12),
          const Text(
            "Admin Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              letterSpacing: 1,
              color: EventHiveColors.text,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined,
              color: EventHiveColors.text),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings_outlined, color: EventHiveColors.text),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  /// Welcome Card
  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: EventHiveColors.primaryLight.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: EventHiveColors.primaryLight.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: EventHiveColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "System Overview",
                  style: TextStyle(
                    color: EventHiveColors.text,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "All systems running smoothly ✅",
                  style: TextStyle(
                    color: EventHiveColors.secondaryLight,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ScaleTransition(
            scale: _pulseAnimation,
            child: CircleAvatar(
              radius: 36,
              backgroundColor: EventHiveColors.primary.withOpacity(0.2),
              child: const Icon(Icons.admin_panel_settings,
                  color: EventHiveColors.primary, size: 32),
            ),
          ),
        ],
      ),
    );
  }

  /// Analytics Grid
  Widget _buildAnalyticsGrid() {
    final stats = [
      {
        "title": "Users",
        "value": "2,847",
        "icon": Icons.people,
        "color": EventHiveColors.primary
      },
      {
        "title": "Events",
        "value": "156",
        "icon": Icons.event,
        "color": EventHiveColors.secondary
      },
      {
        "title": "Revenue",
        "value": "\$24.8K",
        "icon": Icons.monetization_on,
        "color": EventHiveColors.accent
      },
      {
        "title": "System Load",
        "value": "67%",
        "icon": Icons.memory,
        "color": EventHiveColors.secondaryLight
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (context, i) {
        final stat = stats[i];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: EventHiveColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: (stat["color"] as Color).withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(stat["icon"] as IconData,
                  color: stat["color"] as Color, size: 28),
              const Spacer(),
              Text(
                stat["value"] as String,
                style: TextStyle(
                    color: stat["color"] as Color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                stat["title"] as String,
                style: const TextStyle(
                  color: EventHiveColors.text,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Quick Actions
  Widget _buildQuickActionsRow() {
    return Row(
      children: [
        _buildQuickAction("Add User", Icons.person_add, EventHiveColors.primary),
        _buildQuickAction("Create Event", Icons.add_circle, EventHiveColors.accent),
        _buildQuickAction("Reports", Icons.analytics, EventHiveColors.secondary),
      ],
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: color.withOpacity(0.1),
            foregroundColor: color,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          ),
          onPressed: () {},
          icon: Icon(icon, size: 20),
          label: Text(title, style: const TextStyle(fontSize: 13)),
        ),
      ),
    );
  }

  /// Recent Activity
  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EventHiveColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EventHiveColors.secondaryLight.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Recent Activity",
              style: TextStyle(
                  color: EventHiveColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          SizedBox(height: 14),
          ListTile(
            leading: Icon(Icons.person_add, color: EventHiveColors.primary),
            title: Text("New user registered",
                style: TextStyle(color: EventHiveColors.text, fontSize: 14)),
            subtitle: Text("2m ago",
                style: TextStyle(color: EventHiveColors.secondaryLight, fontSize: 12)),
          ),
          ListTile(
            leading: Icon(Icons.event_available, color: EventHiveColors.accent),
            title: Text("Event approved",
                style: TextStyle(color: EventHiveColors.text, fontSize: 14)),
            subtitle: Text("5m ago",
                style: TextStyle(color: EventHiveColors.secondaryLight, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  /// Performance Chart
  Widget _buildPerformanceChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EventHiveColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EventHiveColors.secondaryLight.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Performance",
              style: TextStyle(
                  color: EventHiveColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          SizedBox(height: 16),
          Placeholder(fallbackHeight: 100, color: EventHiveColors.accent),
        ],
      ),
    );
  }
}
