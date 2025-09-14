import 'dart:ui';
import 'package:flutter/material.dart';
import '../organizer/organizer_dashboard.dart'; // Import your organizer dashboard
import '../../themes/colors.dart'; // import EventHiveColors

class UserLogin extends StatefulWidget {
  const UserLogin({super.key, required String name});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  int _tapCount = 0; // Tracks hidden admin taps

  void _mockLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailCtrl.text.trim();
      final password = _passwordCtrl.text;

      if (email == 'user@example.com' && password == 'password123') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Welcome User!')),
        );
        Navigator.pushReplacementNamed(context, '/user');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  void _socialLogin(String provider) async {
    final selectedRole = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text(
            'Continue as',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: EventHiveColors.text,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.person, color: EventHiveColors.primary),
            title: const Text('User'),
            onTap: () => Navigator.pop(context, 'User'),
          ),
          ListTile(
            leading: Icon(Icons.business, color: EventHiveColors.accent),
            title: const Text('Organizer'),
            onTap: () => Navigator.pop(context, 'Organizer'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );

    if (selectedRole != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged in via $provider as $selectedRole')),
      );

      if (selectedRole == 'Organizer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrganizerDashboard()),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/user');
      }
    }
  }

  void _handleHiddenAdminTap() {
    setState(() {
      _tapCount++;
      if (_tapCount >= 7) {
        _tapCount = 0;
        Navigator.pushNamed(context, '/login_admin');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              EventHiveColors.primary, // Teal
              EventHiveColors.accent,  // Peach Orange
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _handleHiddenAdminTap,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.network(
                      'https://img.icons8.com/fluency/48/event-accepted.png',
                      width: 48,
                      height: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'EventHives',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manage your events seamlessly',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),

                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: EventHiveColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Welcome back! Please enter your details',
                            style: TextStyle(
                              fontSize: 14,
                              color: EventHiveColors.secondaryLight,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Email
                          TextFormField(
                            controller: _emailCtrl,
                            decoration: InputDecoration(
                              labelText: 'E-mail',
                              labelStyle: TextStyle(color: EventHiveColors.text),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: EventHiveColors.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: EventHiveColors.primary),
                              ),
                              filled: true,
                              fillColor: EventHiveColors.background,
                            ),
                            validator: (val) =>
                            val == null || val.isEmpty ? 'Enter email' : null,
                          ),
                          const SizedBox(height: 16),

                          // Password
                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: EventHiveColors.text),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: EventHiveColors.primary,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: EventHiveColors.secondary,
                                ),
                                onPressed: () {
                                  setState(() =>
                                  _obscurePassword = !_obscurePassword);
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: EventHiveColors.primary),
                              ),
                              filled: true,
                              fillColor: EventHiveColors.background,
                            ),
                            validator: (val) =>
                            val == null || val.isEmpty ? 'Enter password' : null,
                          ),
                          const SizedBox(height: 16),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/forgot_user'),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: EventHiveColors.accent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _mockLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: EventHiveColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 4,
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: EventHiveColors.secondaryLight),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('Or Sign in with'),
                              ),
                              Expanded(
                                child: Divider(color: EventHiveColors.secondaryLight),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _socialButton(
                                imageUrl:
                                'https://img.icons8.com/color/48/google-logo.png',
                                onTap: () => _socialLogin('Google'),
                              ),
                              const SizedBox(width: 20),
                              _socialButton(
                                imageUrl:
                                'https://img.icons8.com/3d-fluency/94/facebook-circled.png',
                                onTap: () => _socialLogin('Facebook'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'By signing in, you agree to our Terms of Service and Privacy Policy',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(color: EventHiveColors.text),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/signup_user'),
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: EventHiveColors.accent,
                                    fontWeight: FontWeight.bold,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton({required String imageUrl, required VoidCallback onTap}) {
    return Material(
      color: EventHiveColors.background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.network(
            imageUrl,
            width: 28,
            height: 28,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
