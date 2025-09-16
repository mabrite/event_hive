import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../widgets/admin_drawer.dart';
import '../../themes/colors.dart';

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              EventHiveColors.background,
              EventHiveColors.background,
              EventHiveColors.primaryLight.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 24),
              _buildAnalyticsGrid(),
              const SizedBox(height: 24),
              _buildQuickActionsRow(),
              const SizedBox(height: 24),
              _buildSectionTitle("Recent Activity"),
              const SizedBox(height: 12),
              _buildRecentActivity(),
              const SizedBox(height: 24),
              // _buildSectionTitle("System Performance"),
              // const SizedBox(height: 12),
              // _buildPerformanceChart(),
            ],
          ),
        ),
      ),
    );
  }

  /// Modern AppBar
  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: EventHiveColors.primary),
      title: Row(
        children: [
          AnimatedBuilder(
            animation: _rotateAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotateAnimation.value,
                child: const Icon(Icons.dashboard, color: EventHiveColors.primary),
              );
            },
          ),
          const SizedBox(width: 12),
          const Text(
            "Admin Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: EventHiveColors.text,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Badge(
            backgroundColor: EventHiveColors.accent,
            label: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10)),
            child: const Icon(Icons.notifications_outlined, color: EventHiveColors.primary),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings_outlined, color: EventHiveColors.primary),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Welcome Card
  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back, Admin!",
                  style: TextStyle(
                    color: EventHiveColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Dashboard Overview",
                  style: TextStyle(
                    color: EventHiveColors.text,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "All systems running smoothly ✅",
                  style: TextStyle(
                    color: EventHiveColors.secondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: EventHiveColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Last login: Today at 09:42 AM",
                    style: TextStyle(
                      color: EventHiveColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: EventHiveColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.admin_panel_settings,
                color: EventHiveColors.primary,
                size: 36,
              ),
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
        "title": "Total Users",
        "value": "2,847",
        "change": "+12%",
        "icon": Icons.people_outline,
        "color": EventHiveColors.primary
      },
      {
        "title": "Active Events",
        "value": "156",
        "change": "+5%",
        "icon": Icons.event,
        "color": EventHiveColors.secondary
      },
      {
        "title": "Revenue",
        "value": "\$24.8K",
        "change": "+23%",
        "icon": Icons.monetization_on_outlined,
        "color": EventHiveColors.accent
      },
      {
        "title": "System Load",
        "value": "67%",
        "change": "-3%",
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
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, i) {
        final stat = stats[i];
        final isPositive = (stat["change"] as String).contains('+');

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (stat["color"] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(stat["icon"] as IconData,
                        color: stat["color"] as Color, size: 20),
                  ),
                  Text(
                    stat["change"] as String,
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                stat["value"] as String,
                style: TextStyle(
                  color: stat["color"] as Color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat["title"] as String,
                style: TextStyle(
                  color: EventHiveColors.text.withOpacity(0.7),
                  fontSize: 12,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Quick Actions"),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickAction("Add User", Icons.person_add, EventHiveColors.primary),
              const SizedBox(width: 12),
              _buildQuickAction("Create Event", Icons.add_circle, EventHiveColors.accent),
              const SizedBox(width: 12),
              _buildQuickAction("Reports", Icons.analytics, EventHiveColors.secondary),
              const SizedBox(width: 12),
              _buildQuickAction("Settings", Icons.settings, EventHiveColors.secondaryLight),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color) {
    return Container(
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
        onPressed: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Recent Activity
  Widget _buildRecentActivity() {
    final activities = [
      {
        "title": "New user registered",
        "subtitle": "John Doe joined the platform",
        "time": "2m ago",
        "icon": Icons.person_add,
        "color": EventHiveColors.primary
      },
      {
        "title": "Event approved",
        "subtitle": "Tech Conference 2024 is now live",
        "time": "5m ago",
        "icon": Icons.event_available,
        "color": EventHiveColors.accent
      },
      {
        "title": "Payment processed",
        "subtitle": "\$240.00 received for event ticket",
        "time": "15m ago",
        "icon": Icons.payment,
        "color": Colors.green
      },
      {
        "title": "Support ticket",
        "subtitle": "New ticket #4872 from Sarah Johnson",
        "time": "30m ago",
        "icon": Icons.support_agent,
        "color": EventHiveColors.secondary
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: activities.map((activity) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (activity["color"] as Color).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(activity["icon"] as IconData,
                  color: activity["color"] as Color, size: 20),
            ),
            title: Text(
              activity["title"] as String,
              style: const TextStyle(
                color: EventHiveColors.text,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              activity["subtitle"] as String,
              style: TextStyle(
                color: EventHiveColors.text.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
            trailing: Text(
              activity["time"] as String,
              style: TextStyle(
                color: EventHiveColors.text.withOpacity(0.5),
                fontSize: 11,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Performance Chart
  // Widget _buildPerformanceChart() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               "System Performance",
  //               style: TextStyle(
  //                 color: EventHiveColors.text,
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 15,
  //               ),
  //             ),
  //             Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //               decoration: BoxDecoration(
  //                 color: Colors.green.withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Text(
  //                 "Stable",
  //                 style: TextStyle(
  //                   color: Colors.green,
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         Container(
  //           height: 120,
  //           decoration: BoxDecoration(
  //             color: EventHiveColors.background,
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           // child: Center(
  //           //   child: Text(
  //           //     "Performance Chart",
  //           //     style: TextStyle(
  //           //       color: EventHiveColors.text.withOpacity(0.5),
  //           //     ),
  //           //   ),
  //           // ),
  //         ),
  //         // const SizedBox(height: 16),
  //         // Row(
  //         //   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         //   children: [
  //         //     _buildMetric("CPU", "42%", EventHiveColors.primary),
  //         //     _buildMetric("Memory", "67%", EventHiveColors.accent),
  //         //     _buildMetric("Storage", "38%", EventHiveColors.secondary),
  //         //     _buildMetric("Network", "24%", EventHiveColors.secondaryLight),
  //         //   ],
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMetric(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: EventHiveColors.text.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: EventHiveColors.text,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
}