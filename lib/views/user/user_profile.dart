import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../auth/user_login.dart';
import '../settings/edit_profile_screen.dart';
import '../settings/change_password_screen.dart';
import '../settings/appearance_screen.dart';
import '../settings/language_settings_screen.dart';
import '../settings/notifications_screen.dart';
import '../settings/two_factor_screen.dart';
import '../settings/login_activity_screen.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                EventHiveColors.primary,
                EventHiveColors.secondary,
                Colors.white,
              ],
              stops: [0.0, 0.3, 1.0],
            ),
          ),
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Hero(tag: "profile-avatar", child: _buildProfileImage()),
                      const SizedBox(height: 20),
                      _buildUserName(),
                      const SizedBox(height: 15),
                      _buildUserStats(),
                      const SizedBox(height: 30),
                      _buildSettingsSection(context),
                      const SizedBox(height: 30),
                      _buildLogoutButton(context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------- HEADER ----------
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 7),
      child: Row(
        children: [
          _circleButton(
            icon: Icons.arrow_back_ios_new,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 15),
          const Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          _circleButton(
            icon: Icons.edit,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: EventHiveColors.primary, size: 18),
      ),
    );
  }

  /// ---------- PROFILE IMAGE ----------
  Widget _buildProfileImage() {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF5F5F5)],
        ),
        boxShadow: [
          BoxShadow(
            color: EventHiveColors.primary.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 3,
          ),
        ],
      ),
      child: const Icon(
        Icons.person,
        color: EventHiveColors.primary,
        size: 60,
      ),
    );
  }

  /// ---------- USER NAME ----------
  Widget _buildUserName() {
    return const Text(
      "Zigah Mabel",
      style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  /// ---------- USER STATS ----------
  Widget _buildUserStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem("Events", "12"),
          _divider(),
          _buildStatItem("Following", "45"),
          _divider(),
          _buildStatItem("Followers", "108"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 30,
    color: Colors.white.withOpacity(0.3),
  );

  /// ---------- SETTINGS ----------
  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              "Settings & Preferences",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: EventHiveColors.primary,
              ),
            ),
          ),
          _buildSettingsTile(
            context,
            Icons.lock_outline,
            "Change Password",
            const ChangePasswordScreen(),
          ),
          _buildDivider(),
          _buildSettingsTile(
            context,
            Icons.palette_outlined,
            "Appearance",
            AppearanceScreen(),
          ),
          _buildDivider(),
          _buildSettingsTile(
            context,
            Icons.language_outlined,
            "Language Settings",
            const LanguageSettingsScreen(),
          ),
          _buildDivider(),
          _buildSettingsTile(
            context,
            Icons.notifications_outlined,
            "Notifications",
            const NotificationsScreen(),
          ),
          _buildDivider(),
          _buildSettingsTile(
            context,
            Icons.security_outlined,
            "Two-Factor Authentication",
            const TwoFactorScreen(),
          ),
          _buildDivider(),
          _buildSettingsTile(
            context,
            Icons.visibility_outlined,
            "Login Activity",
            const LoginActivityScreen(),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
      BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: EventHiveColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: EventHiveColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: EventHiveColors.text,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: EventHiveColors.primary),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: const Color(0xFFF7FAFC),
    );
  }

  /// ---------- LOGOUT ----------
  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const UserLogin(name: "Guest"),
            ),
                (route) => false,
          );
        },
        icon: const Icon(Icons.logout_rounded, size: 20, color: Colors.white),
        label: const Text(
          "Logout",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: EventHiveColors.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}
