import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/colors.dart'; // Import EventHiveColors

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _loginAdmin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      HapticFeedback.lightImpact();
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => _isLoading = false);
        HapticFeedback.heavyImpact();
        Navigator.pushReplacementNamed(context, '/admin');
      }
    } else {
      HapticFeedback.selectionClick();
    }
  }

  void _loginWithGoogle() async {
    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _isLoading = false);
      HapticFeedback.heavyImpact();
      Navigator.pushReplacementNamed(context, '/admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background, // Soft Grey
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 100,
                  color: EventHiveColors.primary, // Teal
                ),
                const SizedBox(height: 20),
                const Text(
                  'Admin Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: EventHiveColors.text, // Dark Charcoal
                  ),
                ),
                const SizedBox(height: 30),
                // Email
                TextFormField(
                  controller: _emailCtrl,
                  style: const TextStyle(color: EventHiveColors.text),
                  decoration: InputDecoration(
                    hintText: 'Enter admin email',
                    hintStyle:
                    const TextStyle(color: EventHiveColors.secondaryLight),
                    prefixIcon: const Icon(Icons.email,
                        color: EventHiveColors.primary),
                    filled: true,
                    fillColor: EventHiveColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Enter email' : null,
                ),
                const SizedBox(height: 20),
                // Password
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: EventHiveColors.text),
                  decoration: InputDecoration(
                    hintText: 'Enter password',
                    hintStyle:
                    const TextStyle(color: EventHiveColors.secondaryLight),
                    prefixIcon: const Icon(Icons.lock,
                        color: EventHiveColors.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: EventHiveColors.secondaryLight,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    filled: true,
                    fillColor: EventHiveColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Enter password' : null,
                ),
                const SizedBox(height: 30),
                // Login Button
                _isLoading
                    ? const CircularProgressIndicator(
                  color: EventHiveColors.primary,
                )
                    : ElevatedButton(
                  onPressed: _loginAdmin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EventHiveColors.accent,
                    foregroundColor: EventHiveColors.text,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                // Google Login
                TextButton(
                  onPressed: _loginWithGoogle,
                  child: const Text(
                    'Login with Google',
                    style: TextStyle(color: EventHiveColors.primary),
                  ),
                ),
                const SizedBox(height: 20),
                // Forgot Password
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin_forgot_password');
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: EventHiveColors.secondaryLight),
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
