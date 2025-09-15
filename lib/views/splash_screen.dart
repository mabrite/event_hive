import 'dart:async';
import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../main.dart'; // to navigate into LandingPage

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

    // Navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    });
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
                      text: "Hive",
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
