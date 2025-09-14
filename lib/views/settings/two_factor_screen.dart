import 'package:flutter/material.dart';
import '../../themes/colors.dart'; // Import your global colors

class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({super.key});

  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen> {
  final _codeController = TextEditingController();
  bool _is2FAEnabled = false; // false: enable phase, true: verify phase

  @override
  Widget build(BuildContext context) {
    final isVerifyPhase = _is2FAEnabled;

    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: EventHiveColors.secondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: EventHiveColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Two-Factor Authentication",
          style: TextStyle(
            color: EventHiveColors.secondary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: EventHiveColors.secondary.withOpacity(0.15),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isVerifyPhase) ...[
                const Text(
                  "Enable Two-Factor Authentication",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: EventHiveColors.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Add an extra layer of protection to your account for enhanced security.",
                  style: TextStyle(
                    fontSize: 16,
                    color: EventHiveColors.secondary.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                const Text(
                  "Enter Verification Code",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: EventHiveColors.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    hintText: "••••••",
                    filled: true,
                    fillColor: EventHiveColors.background,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: EventHiveColors.secondary,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: EventHiveColors.primary,
                        width: 3,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    letterSpacing: 12,
                    fontWeight: FontWeight.w600,
                    color: EventHiveColors.secondary,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_is2FAEnabled) {
                      // Verify the code logic here
                    } else {
                      setState(() => _is2FAEnabled = true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EventHiveColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    shadowColor: EventHiveColors.primary.withOpacity(0.5),
                  ),
                  child: Text(
                    isVerifyPhase ? "Verify" : "Enable 2FA",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
