import 'package:flutter/material.dart';
import '../views/admin/admin_dashboard.dart';
import '../views/admin/admin_events.dart';
import '../views/admin/admin_users.dart';
import '../views/admin/admin_feedback.dart';
import '../themes/colors.dart'; // ✅ Import your EventHiveColors

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -300,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Container(
            width: 280,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  EventHiveColors.secondary, // dark grey
                  EventHiveColors.text,      // charcoal
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: EventHiveColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Drawer(
              backgroundColor: Colors.transparent,
              child: Column(
                children: [
                  _buildFuturisticHeader(),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      children: [
                        _buildAnimatedDrawerItem(
                          context,
                          index: 0,
                          icon: Icons.dashboard_outlined,
                          activeIcon: Icons.dashboard,
                          text: 'DASHBOARD',
                          destination: const AdminDashboard(),
                        ),
                        const SizedBox(height: 8),
                        _buildAnimatedDrawerItem(
                          context,
                          index: 1,
                          icon: Icons.event_outlined,
                          activeIcon: Icons.event,
                          text: 'EVENTS',
                          destination: const AdminEvents(),
                        ),
                        const SizedBox(height: 8),
                        _buildAnimatedDrawerItem(
                          context,
                          index: 2,
                          icon: Icons.people_outline,
                          activeIcon: Icons.people,
                          text: 'USERS',
                          destination: const AdminUsers(),
                        ),
                        const SizedBox(height: 8),
                        _buildAnimatedDrawerItem(
                          context,
                          index: 3,
                          icon: Icons.feedback_outlined,
                          activeIcon: Icons.feedback,
                          text: 'FEEDBACK',
                          destination: const AdminFeedback(),
                        ),
                        const SizedBox(height: 30),
                        _buildGlowingDivider(),
                        const SizedBox(height: 20),
                        _buildLogoutButton(),
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

  Widget _buildFuturisticHeader() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EventHiveColors.primary.withOpacity(0.8),
            EventHiveColors.accent.withOpacity(0.8),
            EventHiveColors.secondary.withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          ...List.generate(20, (index) {
            return AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Positioned(
                  left: (index * 30.0) % 280,
                  top: (index * 15.0) % 200,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3 * _pulseAnimation.value),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            );
          }),
          Positioned(
            left: 30,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(
                  Icons.admin_panel_settings,
                  size: 36,
                  color: Colors.white,
                ),
                SizedBox(height: 15),
                Text(
                  'ADMIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                Text(
                  'CONTROL PANEL',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDrawerItem(
      BuildContext context, {
        required int index,
        required IconData icon,
        required IconData activeIcon,
        required String text,
        required Widget destination,
      }) {
    final isHovered = _hoveredIndex == index;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 200 + (index * 100)),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset((1 - value) * 100, 0),
          child: Opacity(
            opacity: value,
            child: MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = index),
              onExit: (_) => setState(() => _hoveredIndex = null),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: isHovered
                      ? LinearGradient(
                    colors: [
                      EventHiveColors.primary.withOpacity(0.3),
                      EventHiveColors.accent.withOpacity(0.3),
                    ],
                  )
                      : null,
                  border: Border.all(
                    color: isHovered
                        ? EventHiveColors.primary.withOpacity(0.5)
                        : Colors.transparent,
                    width: 1,
                  ),
                  boxShadow: isHovered
                      ? [
                    BoxShadow(
                      color: EventHiveColors.primary.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                      : null,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  leading: Icon(
                    isHovered ? activeIcon : icon,
                    color: isHovered
                        ? EventHiveColors.primary
                        : Colors.white70,
                    size: 24,
                  ),
                  title: Text(
                    text,
                    style: TextStyle(
                      color: isHovered ? Colors.white : Colors.white70,
                      fontWeight: isHovered ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),
                  trailing: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isHovered ? 1 : 0,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: EventHiveColors.primary,
                      size: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => destination),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlowingDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      height: 1,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.transparent,
            EventHiveColors.primary,
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: EventHiveColors.primary.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = 99),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: _hoveredIndex == 99
              ? LinearGradient(
            colors: [
              EventHiveColors.accent,
              EventHiveColors.primary,
            ],
          )
              : null,
          border: Border.all(
            color: _hoveredIndex == 99
                ? EventHiveColors.accent
                : EventHiveColors.accent.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          leading: Icon(
            Icons.logout,
            color:
            _hoveredIndex == 99 ? Colors.white : EventHiveColors.accent,
            size: 24,
          ),
          title: Text(
            'LOGOUT',
            style: TextStyle(
              color: _hoveredIndex == 99 ? Colors.white : EventHiveColors.accent,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
          trailing: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _hoveredIndex == 99 ? 1 : 0,
            child: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
              size: 16,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            // TODO: Implement logout functionality
          },
        ),
      ),
    );
  }
}
