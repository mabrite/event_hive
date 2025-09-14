import 'package:flutter/material.dart';
import '../../themes/colors.dart'; // import your EventHiveColors

class UserFeedback extends StatefulWidget {
  const UserFeedback({super.key});

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  int selectedStars = 0;
  final TextEditingController _controller = TextEditingController();

  final List<String> tags = [
    "Great quality overall",
    "Loved the packaging",
    "Arrived on time",
    "Minor issue, but still happy",
    "Would order again",
    "Helpful support"
  ];

  final Set<String> selectedTags = {};

  void _toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
  }

  void _submit() {
    if (selectedStars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please rate your experience before submitting.")),
      );
      return;
    }

    final feedbackData = {
      "rating": selectedStars,
      "tags": selectedTags.toList(),
      "comments": _controller.text.trim(),
      "submittedAt": DateTime.now().toIso8601String(),
    };

    // Example: send this data to backend or Firebase
    print("Feedback Submitted: $feedbackData");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thanks for your feedback!")),
    );

    Navigator.pop(context);
  }

  Widget _buildStar(int index) {
    List<String> emojis = ["😡", "😕", "😊", "😍", "🤩"];
    return GestureDetector(
      onTap: () => setState(() => selectedStars = index + 1),
      child: Column(
        children: [
          Icon(
            Icons.star,
            size: 36,
            color: index < selectedStars
                ? EventHiveColors.primary
                : Colors.grey.shade300,
          ),
          const SizedBox(height: 6),
          Text(
            emojis[index],
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: EventHiveColors.secondaryLight),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Close feedback',
                ),
              ),
              const SizedBox(height: 4),

              Text(
                "Your Feedback Matters",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: EventHiveColors.text,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                "It takes less than 60 seconds to complete",
                style: TextStyle(
                  color: EventHiveColors.secondaryLight,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                "How Was Your Overall Experience?",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: EventHiveColors.text,
                ),
              ),
              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, _buildStar),
              ),

              const SizedBox(height: 36),

              Text(
                "What did you think?",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: EventHiveColors.text,
                ),
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: tags.map((tag) {
                  final isSelected = selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : EventHiveColors.text,
                      fontWeight: FontWeight.w600,
                    ),
                    selected: isSelected,
                    onSelected: (_) => _toggleTag(tag),
                    backgroundColor: Colors.white,
                    selectedColor: EventHiveColors.primary,
                    checkmarkColor: Colors.white,
                    side: BorderSide(color: EventHiveColors.primary),
                    elevation: isSelected ? 4 : 1,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 36),

              Text(
                "What could’ve made it perfect?",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: EventHiveColors.text,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _controller,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Loved most of it! One small thing...",
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: EventHiveColors.primary),
                  ),
                ),
                cursorColor: EventHiveColors.primary,
                style: TextStyle(fontSize: 16, color: EventHiveColors.text),
              ),

              const SizedBox(height: 30),

              Center(
                child: Text(
                  "Submit feedback for a chance to win a free hamper!",
                  style: TextStyle(
                    fontSize: 14,
                    color: EventHiveColors.secondaryLight,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EventHiveColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black45,
                  ),
                  child: const Text(
                    "Submit Feedback",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: EventHiveColors.accent,
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  child: const Text("Skip"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
