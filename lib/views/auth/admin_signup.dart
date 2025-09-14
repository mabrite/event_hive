import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/colors.dart'; // import EventHiveColors

class AdminSignup extends StatefulWidget {
  const AdminSignup({super.key});

  @override
  State<AdminSignup> createState() => _AdminSignupState();
}

class _AdminSignupState extends State<AdminSignup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  void _signupAdmin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      HapticFeedback.lightImpact();
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => _isLoading = false);
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin Account Created!')),
        );
        Navigator.pushReplacementNamed(context, '/login_admin');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.admin_panel_settings,
                      size: 64, color: EventHiveColors.primary),
                ),
                const SizedBox(height: 12),
                Text(
                  'Admin Portal',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: EventHiveColors.text,
                  ),
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Create Admin Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: EventHiveColors.text,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Email
                TextFormField(
                  controller: _emailCtrl,
                  decoration: _inputDecoration(
                    'admin@email.com',
                    icon: Icons.email_outlined,
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Enter email' : null,
                ),
                const SizedBox(height: 16),
                // Password
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration(
                    'Password',
                    icon: Icons.lock_outline,
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
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Enter password' : null,
                ),
                const SizedBox(height: 16),
                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordCtrl,
                  obscureText: _obscureConfirmPassword,
                  decoration: _inputDecoration(
                    'Confirm Password',
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: EventHiveColors.secondaryLight,
                      ),
                      onPressed: () {
                        setState(() => _obscureConfirmPassword =
                        !_obscureConfirmPassword);
                      },
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Confirm your password';
                    }
                    if (val != _passwordCtrl.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator(
                    color: EventHiveColors.primary)
                    : ElevatedButton(
                  onPressed: _signupAdmin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EventHiveColors.primary,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.person_add, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'OR',
                  style: TextStyle(
                    color: EventHiveColors.secondaryLight,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                _socialButton(
                  icon: Icons.g_mobiledata,
                  text: 'Sign up with Google',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _socialButton(
                  icon: Icons.facebook,
                  text: 'Sign up with Facebook',
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                          context, '/login_admin'),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: EventHiveColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint,
      {IconData? icon, Widget? suffixIcon}) {
    return InputDecoration(
      prefixIcon:
      icon != null ? Icon(icon, color: EventHiveColors.secondaryLight) : null,
      suffixIcon: suffixIcon,
      hintText: hint,
      hintStyle: TextStyle(color: EventHiveColors.secondaryLight),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: EventHiveColors.background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: EventHiveColors.text),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: EventHiveColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
