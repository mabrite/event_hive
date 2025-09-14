import 'package:flutter/material.dart';
import '../../themes/colors.dart'; // Import EventHiveColors
import 'user_login.dart';

class UserForgotPassword extends StatefulWidget {
  const UserForgotPassword({super.key});

  @override
  State<UserForgotPassword> createState() => _UserForgotPasswordState();
}

class _UserForgotPasswordState extends State<UserForgotPassword> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset link sent!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserLogin(name: '')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: EventHiveColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please enter your email address\nto request a password reset",
                  style: TextStyle(
                    fontSize: 14,
                    color: EventHiveColors.secondaryLight,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailCtrl,
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Email required' : null,
                  style: TextStyle(color: EventHiveColors.text),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined,
                        color: EventHiveColors.secondaryLight),
                    hintText: "abc@email.com",
                    hintStyle:
                    TextStyle(color: EventHiveColors.secondaryLight),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: EventHiveColors.primary),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: EventHiveColors.primary),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EventHiveColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "SEND",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
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
