import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import 'user_login.dart';
import '../organizer/organizer_dashboard.dart'; // Organizer dashboard import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({super.key});

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  String _selectedRole = 'User';
  String? _selectedGender;
  DateTime? _selectedDOB;

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select your gender.")),
        );
        return;
      }
      if (_selectedDOB == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select your date of birth.")),
        );
        return;
      }
      if (_passwordCtrl.text != _confirmPasswordCtrl.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match.")),
        );
        return;
      }

      try {
        // ✅ Create user with FirebaseAuth
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
        );

        User? user = userCredential.user;

        if (user != null) {
          // ✅ Save user details in Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': _nameCtrl.text.trim(),
            'email': _emailCtrl.text.trim(),
            'gender': _selectedGender,
            'dob': _selectedDOB!.toIso8601String(),
            'role': _selectedRole.isNotEmpty ? _selectedRole : 'User',
            'phone': '',
            'organization': '',
            'createdAt': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Account created as $_selectedRole!")),
          );

          if (_selectedRole == 'Organizer') {
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
          SnackBar(content: Text(e.message ?? "Signup failed")),
        );
      }
    }
  }

  void _selectDOB() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: EventHiveColors.primary,
              onPrimary: Colors.white,
              onSurface: EventHiveColors.text,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) setState(() => _selectedDOB = pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: EventHiveColors.text,
                  ),
                ),
                const SizedBox(height: 24),

                _buildTextField(_nameCtrl, 'Full name',
                    'https://img.icons8.com/color/48/user.png'),
                const SizedBox(height: 16),
                _buildTextField(_emailCtrl, 'abc@email.com',
                    'https://img.icons8.com/color/48/email.png',
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildTextField(_passwordCtrl, 'Your password',
                    'https://img.icons8.com/color/48/lock.png',
                    obscure: true),
                const SizedBox(height: 16),
                _buildTextField(_confirmPasswordCtrl, 'Confirm password',
                    'https://img.icons8.com/color/48/lock.png',
                    obscure: true),
                const SizedBox(height: 16),

                // Gender
                Text(
                  'Gender',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: EventHiveColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Male',
                          groupValue: _selectedGender,
                          onChanged: (val) =>
                              setState(() => _selectedGender = val),
                          activeColor: EventHiveColors.primary,
                        ),
                        const Text('Male'),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Female',
                          groupValue: _selectedGender,
                          onChanged: (val) =>
                              setState(() => _selectedGender = val),
                          activeColor: EventHiveColors.primary,
                        ),
                        const Text('Female'),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Other',
                          groupValue: _selectedGender,
                          onChanged: (val) =>
                              setState(() => _selectedGender = val),
                          activeColor: EventHiveColors.primary,
                        ),
                        const Text('Other'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 13),

                // DOB
                GestureDetector(
                  onTap: _selectDOB,
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: _selectedDOB == null
                            ? 'Select your date of birth'
                            : '${_selectedDOB!.day}/${_selectedDOB!.month}/${_selectedDOB!.year}',
                        prefixIcon: Image.network(
                            'https://img.icons8.com/color/48/calendar.png',
                            width: 24,
                            height: 24),
                        filled: true,
                        fillColor: EventHiveColors.background,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          BorderSide(color: EventHiveColors.secondaryLight),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          BorderSide(color: EventHiveColors.secondaryLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: EventHiveColors.primary, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Role
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Register as',
                    filled: true,
                    fillColor: EventHiveColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      BorderSide(color: EventHiveColors.secondaryLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      BorderSide(color: EventHiveColors.secondaryLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: EventHiveColors.primary, width: 1.5),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'User', child: Text('User')),
                    DropdownMenuItem(value: 'Organizer', child: Text('Organizer')),
                  ],
                  onChanged: (value) => setState(() => _selectedRole = value!),
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EventHiveColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: EventHiveColors.secondaryLight),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UserLogin(name: ''),
                          ),
                        );
                      },
                      child: Text(
                        'Sign in',
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

  Widget _buildTextField(TextEditingController controller, String hint,
      String iconUrl,
      {bool obscure = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.network(iconUrl, width: 24, height: 24),
        ),
        filled: true,
        fillColor: EventHiveColors.background,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: EventHiveColors.secondaryLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: EventHiveColors.secondaryLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color: EventHiveColors.primary, width: 1.5),
        ),
      ),
      validator: (val) =>
      val == null || val.isEmpty ? 'Please enter $hint' : null,
    );
  }

  Widget _socialButton(String label, String iconUrl, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Image.network(iconUrl, height: 24, width: 24),
      label: Text(label, style: TextStyle(color: EventHiveColors.text)),
      style: OutlinedButton.styleFrom(
        backgroundColor: EventHiveColors.background,
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: EventHiveColors.secondaryLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
