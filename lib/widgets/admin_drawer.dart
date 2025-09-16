import 'package:event_hive/views/user/user_main.dart';
import 'package:flutter/material.dart';
import '../views/admin/admin_dashboard.dart';
import '../views/admin/admin_events.dart';
import '../views/admin/admin_users.dart';
import '../views/admin/admin_feedback.dart';
import '../themes/colors.dart';
import '../services/auth_service.dart'; // You'll need to create this
import '../views/auth/user_login.dart'; // You'll need to create this

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
  int? _selectedIndex = 0;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -300,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
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

  // Logout method
  Future<void> _logout(BuildContext context) async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      // Show confirmation dialog
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );

      if (shouldLogout == true) {
        // Call your authentication service to logout
        await AuthService.logout();

        // Navigate to login screen and remove all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const UserLogin(name: '')),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      // Show error message if logout fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoggingOut = false;
      });
    }
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
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Drawer(
              backgroundColor: Colors.transparent,
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      children: [
                        _buildDrawerItem(
                          context,
                          index: 0,
                          icon: Icons.dashboard_outlined,
                          activeIcon: Icons.dashboard,
                          text: 'Dashboard',
                          destination: const AdminDashboard(),
                        ),
                        const SizedBox(height: 4),
                        _buildDrawerItem(
                          context,
                          index: 1,
                          icon: Icons.event_outlined,
                          activeIcon: Icons.event,
                          text: 'Events',
                          destination: const AdminEvents(),
                        ),
                        const SizedBox(height: 4),
                        _buildDrawerItem(
                          context,
                          index: 2,
                          icon: Icons.people_outline,
                          activeIcon: Icons.people,
                          text: 'Users',
                          destination: const AdminUsers(),
                        ),
                        const SizedBox(height: 4),
                        _buildDrawerItem(
                          context,
                          index: 3,
                          icon: Icons.feedback_outlined,
                          activeIcon: Icons.feedback,
                          text: 'Feedback',
                          destination: const AdminFeedback(),
                        ),
                        const SizedBox(height: 4),
                        _buildDrawerItem(
                          context,
                          index: 3,
                          icon: Icons.dashboard_customize_rounded,
                          activeIcon: Icons.feedback,
                          text: 'User Dashboard',
                          destination: const UserMain(),
                        ),
                        const SizedBox(height: 24),
                        const Divider(height: 1, thickness: 1),
                        const SizedBox(height: 24),
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

  Widget _buildHeader() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: EventHiveColors.primary,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          ...List.generate(15, (index) {
            return Positioned(
              left: (index * 40.0) % 280,
              top: (index * 20.0) % 180,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2 * _pulseAnimation.value),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            );
          }),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your platform',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required int index,
        required IconData icon,
        required IconData activeIcon,
        required String text,
        required Widget destination,
      }) {
    final isHovered = _hoveredIndex == index;
    final isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: isSelected
            ? EventHiveColors.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => destination),
            );
          },
          onHover: (hovering) {
            setState(() {
              _hoveredIndex = hovering ? index : null;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: isSelected
                  ? Border(
                left: BorderSide(
                  color: EventHiveColors.primary,
                  width: 3,
                ),
              )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  isSelected || isHovered ? activeIcon : icon,
                  color: isSelected
                      ? EventHiveColors.primary
                      : EventHiveColors.text.withOpacity(0.7),
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: TextStyle(
                    color: isSelected
                        ? EventHiveColors.primary
                        : EventHiveColors.text,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                if (isHovered)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: EventHiveColors.primary,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    final isHovered = _hoveredIndex == 99;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: isHovered ? Colors.red.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _logout(context),
          onHover: (hovering) {
            setState(() {
              _hoveredIndex = hovering ? 99 : null;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (_isLoggingOut)
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isHovered ? Colors.red : EventHiveColors.text.withOpacity(0.7),
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.logout,
                    color: isHovered ? Colors.red : EventHiveColors.text.withOpacity(0.7),
                    size: 24,
                  ),
                const SizedBox(width: 16),
                Text(
                  _isLoggingOut ? 'Logging out...' : 'Logout',
                  style: TextStyle(
                    color: isHovered ? Colors.red : EventHiveColors.text,
                    fontWeight: isHovered ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}