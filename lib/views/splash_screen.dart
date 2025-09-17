import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../themes/colors.dart';
import '../main.dart';
import 'organizer/organizer_dashboard.dart'; // LandingPage

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Trigger fade-in after small delay
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    _navigateNext();
  }

  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('role') ?? 'User';

    // Wait for 3 seconds splash duration
    await Future.delayed(const Duration(seconds: 3));

    if (isLoggedIn) {
      // Redirect based on role
      if (role == 'Admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else if (role == 'Organizer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrganizerDashboard()),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/user');
      }
    } else {
      // First-time users go to landing
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      body: Stack(
        children: [
          // 🔹 Blurred gradient circles background
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    EventHiveColors.primary.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -60,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    EventHiveColors.accent.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 🔹 Center logo with fade-in
          Center(
            child: AnimatedOpacity(
              duration: const Duration(seconds: 2),
              opacity: _opacity,
              curve: Curves.easeIn,
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                  children: [
                    TextSpan(
                      text: "E",
                      style: TextStyle(color: EventHiveColors.primary),
                    ),
                    TextSpan(
                      text: "vent",
                      style: TextStyle(color: EventHiveColors.text),
                    ),
                    TextSpan(
                      text: "Hives",
                      style: TextStyle(color: EventHiveColors.accent),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}