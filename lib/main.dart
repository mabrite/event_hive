import 'package:flutter/material.dart';
import '../../themes/colors.dart';

// Auth Pages
import 'views/auth/admin_login.dart';
import 'views/auth/admin_signup.dart';
import 'views/auth/admin_forgot_password.dart';
import 'views/auth/user_login.dart';
import 'views/auth/user_signup.dart';
import 'views/auth/user_forgot_password.dart';

// Dashboards
import 'views/user/user_main.dart';
import 'views/admin/admin_main.dart';

// Organizer Module
import 'views/organizer/organizer_main.dart';
import 'views/organizer/organizer_dashboard.dart';
import 'views/organizer/organizer_events.dart';
import 'views/organizer/organizer_profile.dart';
import 'views/organizer/organizer_feedback.dart';
import 'views/organizer/organizer_users.dart';

// Splash
import 'views/splash_screen.dart'; // ✅ import splash

void main() {
  runApp(const EventHivesApp());
}

class EventHivesApp extends StatelessWidget {
  const EventHivesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventHives',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        primaryColor: EventHiveColors.primary,
        scaffoldBackgroundColor: EventHiveColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: EventHiveColors.primary,
          primary: EventHiveColors.primary,
          secondary: EventHiveColors.accent,
          tertiary: EventHiveColors.secondary,
          background: EventHiveColors.background,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: EventHiveColors.text,
          onSurface: EventHiveColors.text,
        ),
      ),
      initialRoute: '/', // ✅ start with splash
      routes: {
        '/': (context) => const SplashScreen(),
        '/landing': (context) => const LandingPage(),

        // User
        '/login_user': (context) => const UserLogin(name: ''),
        '/signup_user': (context) => const UserSignup(),
        '/forgot_user': (context) => const UserForgotPassword(),
        '/user': (context) => UserMain(),

        // Admin
        '/login_admin': (context) => const AdminLogin(),
        '/signup_admin': (context) => const AdminSignup(),
        '/forgot_admin': (context) => const AdminForgotPassword(),
        '/admin': (context) => AdminMain(),

        // Organizer
        '/login_organizer': (context) => const UserLogin(name: ''),
        '/signup_organizer': (context) => const UserSignup(),
        '/organizer': (context) => OrganizerMain(),
        '/organizer_dashboard': (context) => OrganizerDashboard(),
        '/organizer_events': (context) => OrganizerEvents(),
        '/organizer_profile': (context) => OrganizerProfile(),
        '/organizer_feedback': (context) => OrganizerFeedback(),
        '/organizer_users': (context) => OrganizerUsers(),
      },
    );
  }
}

// ✅ LandingPage remains unchanged
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [EventHiveColors.background, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),

                // Logo + Title
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [EventHiveColors.primary, EventHiveColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: EventHiveColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.event_available_rounded,
                      size: 72, color: Colors.white),
                ),
                const SizedBox(height: 24),
                const Text(
                  "EventHives",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: EventHiveColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Where ideas meet people\nand events come alive.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: EventHiveColors.secondaryLight,
                    height: 1.4,
                  ),
                ),
                const Spacer(),

                // Features
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFeature(Icons.event, "Plan"),
                    _buildFeature(Icons.people_alt, "Connect"),
                    _buildFeature(Icons.trending_up, "Grow"),
                  ],
                ),
                const Spacer(),

                // CTA Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EventHiveColors.accent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/login_user'),
                  child: const Text(
                    "Get Started 🚀",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),

                // Sign-up Teaser
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/signup_user'),
                  child: RichText(
                    text: const TextSpan(
                      text: "Not a member yet? ",
                      style: TextStyle(color: EventHiveColors.secondaryLight, fontSize: 14),
                      children: [
                        TextSpan(
                          text: "Sign up now",
                          style: TextStyle(
                            color: EventHiveColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " and unlock surprises 🎁",
                          style: TextStyle(color: EventHiveColors.secondaryLight),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: EventHiveColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: EventHiveColors.primary, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: EventHiveColors.text,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
