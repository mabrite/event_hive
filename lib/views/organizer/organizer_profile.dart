import 'package:flutter/material.dart';
import '../../themes/colors.dart';

class OrganizerProfile extends StatefulWidget {
  const OrganizerProfile({super.key});

  @override
  State<OrganizerProfile> createState() => _OrganizerProfileState();
}

class _OrganizerProfileState extends State<OrganizerProfile> {
  String name = "Alex Organizer";
  String email = "alex.organizer@example.com";
  String phone = "+233 55 123 4567";
  String organization = "EventHive Solutions";

  bool isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = name;
    _emailController.text = email;
    _phoneController.text = phone;
    _organizationController.text = organization;
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveProfile() {
    setState(() {
      name = _nameController.text;
      email = _emailController.text;
      phone = _phoneController.text;
      organization = _organizationController.text;
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Profile updated successfully")),
    );
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login_organizer',
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        title: const Text("Organizer Profile"),
        backgroundColor: EventHiveColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save_rounded : Icons.edit_rounded),
            onPressed: isEditing ? _saveProfile : _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar with gradient ring
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [EventHiveColors.primary, EventHiveColors.accent],
                  ),
                ),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 55,
                    color: EventHiveColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Profile Card
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Card(
                key: ValueKey(isEditing),
                elevation: 6,
                shadowColor: EventHiveColors.secondary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _buildProfileField("Full Name", _nameController, isEditing),
                      _buildProfileField("Email", _emailController, isEditing),
                      _buildProfileField("Phone", _phoneController, isEditing),
                      _buildProfileField("Organization", _organizationController, isEditing),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Logout Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: EventHiveColors.accent,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 5,
              ),
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              label: const Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onPressed: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(
      String label, TextEditingController controller, bool editable) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: editable
          ? TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          labelStyle: TextStyle(color: EventHiveColors.secondary),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: EventHiveColors.primary, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: EventHiveColors.secondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            controller.text,
            style: TextStyle(fontSize: 16, color: EventHiveColors.text),
          ),
        ],
      ),
    );
  }
}
