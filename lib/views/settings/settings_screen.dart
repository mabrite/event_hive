import 'package:flutter/material.dart';
import '../../themes/colors.dart'; // Import your EventHiveColors

class ScreenSetting extends StatefulWidget {
  const ScreenSetting({super.key});

  @override
  State<ScreenSetting> createState() => _ScreenSettingState();
}

class _ScreenSettingState extends State<ScreenSetting> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _twoFactorEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        backgroundColor: EventHiveColors.primary,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle("Account"),
          _buildSettingTile(
            icon: Icons.person,
            title: "Edit Profile",
            subtitle: "Update your personal information",
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.lock,
            title: "Change Password",
            subtitle: "Update your account password",
            onTap: () {},
          ),
          const SizedBox(height: 24),

          _buildSectionTitle("Preferences"),
          SwitchListTile(
            activeColor: EventHiveColors.primary,
            title: const Text("Enable Notifications"),
            subtitle: const Text("Get updates and alerts"),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
            },
          ),
          SwitchListTile(
            activeColor: EventHiveColors.primary,
            title: const Text("Dark Mode"),
            subtitle: const Text("Switch theme to dark"),
            value: _darkModeEnabled,
            onChanged: (val) {
              setState(() => _darkModeEnabled = val);
            },
          ),
          SwitchListTile(
            activeColor: EventHiveColors.primary,
            title: const Text("Two-Factor Authentication"),
            subtitle: const Text("Add extra security to your account"),
            value: _twoFactorEnabled,
            onChanged: (val) {
              setState(() => _twoFactorEnabled = val);
            },
          ),
          const SizedBox(height: 24),

          _buildSectionTitle("More"),
          _buildSettingTile(
            icon: Icons.help_outline,
            title: "Help & Support",
            subtitle: "Get assistance",
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.info_outline,
            title: "About",
            subtitle: "Learn more about EventHives",
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.logout,
            title: "Logout",
            subtitle: "Sign out from your account",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: EventHiveColors.secondary,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      shadowColor: EventHiveColors.primary.withOpacity(0.2),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: EventHiveColors.primary.withOpacity(0.1),
          child: Icon(icon, color: EventHiveColors.primary),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: EventHiveColors.text,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: EventHiveColors.text.withOpacity(0.6)),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: EventHiveColors.accent, size: 18),
        onTap: onTap,
      ),
    );
  }
}
