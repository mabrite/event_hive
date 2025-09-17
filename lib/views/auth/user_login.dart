import 'package:flutter/material.dart';
import '../organizer/organizer_dashboard.dart'; // Organizer dashboard
import '../../themes/colors.dart'; // EventHiveColors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Stay signed in

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
  bool _isLoading = false; // 🔹 Loading state
  int _tapCount = 0; // Hidden admin tap tracker

  @override
  void initState() {
    super.initState();
    _checkStaySignedIn();
  }

  // Check if user is already signed in
  Future<void> _checkStaySignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    bool staySignedIn = prefs.getBool('stay_signed_in') ?? false;
    User? user = FirebaseAuth.instance.currentUser;

    if (staySignedIn && user != null) {
      final snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (snap.exists) {
        final data = snap.data() as Map<String, dynamic>;
        final role = data['role'] ?? 'User';
        if (role == 'Organizer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OrganizerDashboard()),
          );
        } else {
          Navigator.pushReplacementNamed(context, '/user');
        }
      } else {
        await FirebaseAuth.instance.signOut();
      }
    }
  }

  // Login method
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true); // Show loader

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot snap = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!snap.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User details not found")),
          );
          return;
        }

        final data = snap.data() as Map<String, dynamic>;
        final role = data['role'] ?? 'User';

        // Save stay signed in
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('role', role);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome ${data['name']}!')),
        );

        if (role == 'Organizer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OrganizerDashboard()),
          );
        } else {
          Navigator.pushReplacementNamed(context, '/user');
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false); // Hide loader
    }
  }

  // Hidden admin tap
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
    return Stack(
      children: [
        Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [EventHiveColors.primary, EventHiveColors.accent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: _isLoading ? null : _login,
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
                                    if (_isLoading)
                                      const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
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
        ),
        // Full screen loader overlay
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.4),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
