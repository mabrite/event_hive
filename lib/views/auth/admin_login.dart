import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _loginAdmin() async {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.selectionClick();
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    try {
      // 🔑 Firebase Auth Login
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );
      User? user = userCredential.user;

      if (user == null) throw Exception("No user found");

      // 🔍 Firestore role check
      DocumentSnapshot doc =
      await _firestore.collection("users").doc(user.uid).get();

      if (!doc.exists || doc['role'] != "Admin") {
        await _auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Access denied: Not an admin")),
        );
        return;
      }

      if (mounted) {
        HapticFeedback.heavyImpact();

        // Save stay signed in
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('role', 'Admin');

        Navigator.pushReplacementNamed(context, '/admin');
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";
      if (e.code == 'user-not-found') {
        message = "No account found with this email";
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ $message")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 100,
                  color: EventHiveColors.primary,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Admin Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: EventHiveColors.text,
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
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
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