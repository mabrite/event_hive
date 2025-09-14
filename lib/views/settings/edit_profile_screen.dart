// edit_profile_screen.dart
import 'package:flutter/material.dart';
import '../../themes/colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: "Rachel Liu");
  final _emailController = TextEditingController(text: "rachelliu@gmail.com");
  final _heightController = TextEditingController(text: "170");
  final _weightController = TextEditingController(text: "60");
  final _stepsController = TextEditingController(text: "10000");
  final _workoutTimeController = TextEditingController(text: "120");
  TimeOfDay _bedTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);
  DateTime _dob = DateTime(1990, 4, 29);

  String _gender = "Female";
  bool _bedtimeSchedule = true;

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? "am" : "pm";
    return "$hour:${time.minute.toString().padLeft(2, '0')} $period";
  }

  Future<void> _pickDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: EventHiveColors.primary,
            onPrimary: Colors.white,
            onSurface: EventHiveColors.text,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _pickTime(bool isBedTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isBedTime ? _bedTime : _wakeTime,
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: EventHiveColors.primary,
            onPrimary: Colors.white,
            onSurface: EventHiveColors.text,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isBedTime) {
          _bedTime = picked;
        } else {
          _wakeTime = picked;
        }
      });
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: EventHiveColors.primary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: EventHiveColors.secondary),
      filled: true,
      fillColor: EventHiveColors.background,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: EventHiveColors.primary, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }

  Widget _genderSelector() {
    final genders = ["Female", "Male", "Custom"];
    return Row(
      children: genders.map((g) {
        final isSelected = _gender == g;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () => setState(() => _gender = g),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? EventHiveColors.accent : EventHiveColors.background,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: EventHiveColors.accent.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    g,
                    style: TextStyle(
                      color: isSelected ? Colors.white : EventHiveColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        backgroundColor: EventHiveColors.primary,
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 3,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture with camera icon
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 52,
                      backgroundImage: AssetImage("assets/profile_placeholder.png"),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Add image picker logic
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: EventHiveColors.accent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: EventHiveColors.accent.withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // General Details Section
              _sectionTitle("General Details"),
              TextField(
                controller: _nameController,
                decoration: _inputDecoration("Name"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration("Email"),
              ),
              const SizedBox(height: 16),
              _genderSelector(),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDOB,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: _inputDecoration("Birthday").copyWith(
                      suffixIcon: const Icon(Icons.calendar_today, color: EventHiveColors.secondary),
                      hintText: _formatDate(_dob),
                      hintStyle: const TextStyle(color: EventHiveColors.primary),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Physical Stats
              _sectionTitle("Physical Stats"),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Height (cm)"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Weight (kg)"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Workout Plan
              _sectionTitle("Workout Plan"),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _stepsController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Steps per day"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _workoutTimeController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Workout time (mins)"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(true),
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: _inputDecoration("Get in bed").copyWith(
                            hintText: _formatTime(_bedTime),
                            hintStyle: const TextStyle(color: EventHiveColors.primary),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(false),
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: _inputDecoration("Wake up").copyWith(
                            hintText: _formatTime(_wakeTime),
                            hintStyle: const TextStyle(color: EventHiveColors.primary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SwitchListTile(
                value: _bedtimeSchedule,
                onChanged: (v) => setState(() => _bedtimeSchedule = v),
                activeColor: EventHiveColors.accent,
                title: const Text(
                  "Bedtime Schedule",
                  style: TextStyle(color: EventHiveColors.primary, fontWeight: FontWeight.w600),
                ),
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Save profile changes logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EventHiveColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
