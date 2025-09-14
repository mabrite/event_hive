import 'package:flutter/material.dart';
import 'admin_login.dart';
import '../../themes/colors.dart'; // Import your EventHiveColors

class AdminForgotPassword extends StatefulWidget {
  const AdminForgotPassword({super.key});

  @override
  State<AdminForgotPassword> createState() => _AdminForgotPasswordState();
}

class _AdminForgotPasswordState extends State<AdminForgotPassword> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset link sent!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background, // Soft Grey
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: EventHiveColors.secondary, // Slate Grey container
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: EventHiveColors.primary.withOpacity(0.3), // Teal glow
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Admin Password Reset',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: EventHiveColors.background, // Soft Grey text
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailCtrl,
                    style: const TextStyle(color: EventHiveColors.text),
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: const TextStyle(color: EventHiveColors.secondaryLight),
                      filled: true,
                      fillColor: EventHiveColors.background, // Soft grey input background
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (val) =>
                    val == null || val.isEmpty ? 'Email required' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EventHiveColors.accent, // Peach Orange button
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(
                        color: EventHiveColors.text, // Dark Charcoal text
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminLogin()),
                      );
                    },
                    child: const Text(
                      "Back to Login",
                      style: TextStyle(color: EventHiveColors.primaryLight), // Teal light
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
