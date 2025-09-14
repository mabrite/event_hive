import 'package:flutter/material.dart';
import '../../themes/colors.dart'; // <- use your EventHiveColors here

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _minLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _passwordsMatch = false;

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  void _validatePassword(String password) {
    setState(() {
      _minLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#\$&*~]'));
      _passwordsMatch =
          _newPasswordController.text == _confirmPasswordController.text;
    });
  }

  Widget _buildCheckItem(bool condition, String text) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            condition ? Icons.check_circle : Icons.radio_button_unchecked,
            color: condition ? EventHiveColors.primary : Colors.grey.shade400,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: condition ? EventHiveColors.secondary : Colors.grey.shade600,
              fontWeight: condition ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allValid = _minLength &&
        _hasUppercase &&
        _hasLowercase &&
        _hasNumber &&
        _hasSpecialChar &&
        _passwordsMatch;

    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: EventHiveColors.text,
        title: const Text("Change Password"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              "Current Password",
              _currentPasswordController,
              obscureText: !_showCurrent,
              toggle: () => setState(() => _showCurrent = !_showCurrent),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              "New Password",
              _newPasswordController,
              onChanged: _validatePassword,
              obscureText: !_showNew,
              toggle: () => setState(() => _showNew = !_showNew),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              "Confirm Password",
              _confirmPasswordController,
              onChanged: _validatePassword,
              obscureText: !_showConfirm,
              toggle: () => setState(() => _showConfirm = !_showConfirm),
            ),

            if (!_passwordsMatch && _confirmPasswordController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Passwords do not match",
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),

            const SizedBox(height: 28),

            const Text(
              "Password must contain:",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12),

            _buildCheckItem(_minLength, "Minimum 8 characters"),
            _buildCheckItem(_hasLowercase, "At least one lowercase letter"),
            _buildCheckItem(_hasUppercase, "At least one uppercase letter"),
            _buildCheckItem(_hasNumber, "At least one number"),
            _buildCheckItem(_hasSpecialChar, "At least one special character"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: allValid ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password Changed Successfully ✅")),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: allValid
                      ? EventHiveColors.primary
                      : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: allValid ? 4 : 0,
                ),
                child: const Text(
                  "SUBMIT",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hint,
      TextEditingController controller, {
        bool obscureText = true,
        Function(String)? onChanged,
        VoidCallback? toggle,
      }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      cursorColor: EventHiveColors.primary,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: EventHiveColors.primary, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: toggle,
        ),
      ),
    );
  }
}
