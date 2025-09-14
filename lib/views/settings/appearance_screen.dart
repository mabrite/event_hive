import 'dart:ui';
import 'package:flutter/material.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen>
    with SingleTickerProviderStateMixin {
  bool _isDarkMode = false;
  late AnimationController _animationController;
  late Animation<double> _thumbPosition;
  late Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: _isDarkMode ? 1.0 : 0.0,
    );
    _thumbPosition = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _glowPulse = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    // Start the glow pulse animation loop only if dark mode enabled
    if (_isDarkMode) _animationController.forward();
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      if (_isDarkMode) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final appBarColor = _isDarkMode ? Colors.transparent : const Color(0xFF023047);
    final trackColor = _isDarkMode
        ? Colors.tealAccent.withOpacity(0.3)
        : Colors.blue.withOpacity(0.25);
    final glowColor = _isDarkMode ? Colors.tealAccent : Colors.blueAccent;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Appearance"),
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: true,
        foregroundColor: _isDarkMode ? Colors.tealAccent : Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildThemeCard(
                  title: "Light",
                  isActive: !_isDarkMode,
                  onTap: () {
                    if (_isDarkMode) _toggleDarkMode();
                  },
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  icon: Icons.wb_sunny,
                ),
                _buildThemeCard(
                  title: "Dark",
                  isActive: _isDarkMode,
                  onTap: () {
                    if (!_isDarkMode) _toggleDarkMode();
                  },
                  backgroundColor: const Color(0xFF1E1E1E),
                  textColor: Colors.tealAccent,
                  icon: Icons.nights_stay,
                ),
              ],
            ),
            const SizedBox(height: 50),

            // Glowing Toggle Switch
            GestureDetector(
              onTap: _toggleDarkMode,
              child: SizedBox(
                width: 90,
                height: 45,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      width: double.infinity,
                      height: 22,
                      decoration: BoxDecoration(
                        color: trackColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: glowColor.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    AnimatedBuilder(
                      animation: Listenable.merge([_thumbPosition, _glowPulse]),
                      builder: (_, child) {
                        return Align(
                          alignment: Alignment(
                            lerpDouble(-1, 1, _thumbPosition.value)!,
                            0,
                          ),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  glowColor.withOpacity(_glowPulse.value),
                                  glowColor.withOpacity(0.5),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: glowColor.withOpacity(_glowPulse.value),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            Text(
              _isDarkMode
                  ? "Dark mode is enabled"
                  : "Light mode is enabled",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _isDarkMode ? Colors.tealAccent.shade100 : Colors.blueGrey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 150,
        height: 190,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: isActive
              ? Border.all(color: Colors.tealAccent, width: 3)
              : Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: Colors.tealAccent.withOpacity(0.25),
                blurRadius: 25,
                spreadRadius: 6,
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 54, color: textColor),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: textColor,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
