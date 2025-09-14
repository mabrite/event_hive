import 'package:flutter/material.dart';
import '../../themes/colors.dart'; // Import your EventHiveColors

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool push = true;
  bool email = false;
  bool sms = true;

  Widget _buildToggleRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: EventHiveColors.secondary,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: EventHiveColors.primary,
            inactiveThumbColor: Colors.grey.shade300,
            inactiveTrackColor: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: EventHiveColors.secondary,
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.4,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: EventHiveColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: EventHiveColors.secondary.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleRow("Push Notifications", push, (v) {
                setState(() => push = v);
              }),
              const Divider(height: 1, thickness: 1, indent: 20, endIndent: 20),
              _buildToggleRow("Email Notifications", email, (v) {
                setState(() => email = v);
              }),
              const Divider(height: 1, thickness: 1, indent: 20, endIndent: 20),
              _buildToggleRow("SMS Notifications", sms, (v) {
                setState(() => sms = v);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
