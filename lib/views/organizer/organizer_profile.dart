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
      const SnackBar(content: Text("Profile updated successfully")),
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
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: isEditing ? _saveProfile : _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: EventHiveColors.primary.withOpacity(0.2),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: EventHiveColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: EventHiveColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontSize: 16),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: editable
          ? TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: EventHiveColors.secondary),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: EventHiveColors.primary, width: 1.5),
          ),
          enabledBorder: const OutlineInputBorder(),
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
          const SizedBox(height: 4),
          Text(
            controller.text,
            style: TextStyle(fontSize: 16, color: EventHiveColors.text),
          ),
        ],
      ),
    );
  }
}
