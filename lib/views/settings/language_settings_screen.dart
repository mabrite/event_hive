import 'package:flutter/material.dart';
import '../../themes/colors.dart'; // import your EventHiveColors

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selected = 'English';

  final List<Map<String, String>> languages = [
    {'name': 'English', 'flag': '🇬🇧'},
    {'name': 'Spanish', 'flag': '🇪🇸'},
    {'name': 'French', 'flag': '🇫🇷'},
    {'name': 'German', 'flag': '🇩🇪'},
    {'name': 'Italian', 'flag': '🇮🇹'},
    {'name': 'Chinese (Simplified)', 'flag': '🇨🇳'},
    {'name': 'Japanese', 'flag': '🇯🇵'},
    {'name': 'Korean', 'flag': '🇰🇷'},
    {'name': 'Russian', 'flag': '🇷🇺'},
    {'name': 'Portuguese', 'flag': '🇵🇹'},
    {'name': 'Arabic', 'flag': '🇸🇦'},
    {'name': 'Hindi', 'flag': '🇮🇳'},
    {'name': 'Turkish', 'flag': '🇹🇷'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: EventHiveColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Language Settings',
          style: TextStyle(
            color: EventHiveColors.text,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ListView.separated(
                  itemCount: languages.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    final isSelected = lang['name'] == _selected;

                    return ListTile(
                      leading: Text(
                        lang['flag']!,
                        style: const TextStyle(fontSize: 30),
                      ),
                      title: Text(
                        lang['name']!,
                        style: TextStyle(
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? EventHiveColors.text
                              : EventHiveColors.secondaryLight,
                          fontSize: 17,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle,
                          color: EventHiveColors.primary, size: 26)
                          : const SizedBox(width: 26),
                      onTap: () {
                        setState(() {
                          _selected = lang['name']!;
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Apply language change logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Language set to $_selected'),
                      backgroundColor: EventHiveColors.primary,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: EventHiveColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
