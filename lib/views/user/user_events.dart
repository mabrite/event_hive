import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_hive/views/user/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../themes/colors.dart';

class UserEvents extends StatefulWidget {
  const UserEvents({super.key});

  @override
  State<UserEvents> createState() => _UserEventsState();
}

class _UserEventsState extends State<UserEvents> {
  String selectedCategory = 'UPCOMING';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: EventHiveColors.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('events').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final now = DateTime.now();

                    final events = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;

                      int day = int.tryParse(data['date'] ?? '1') ?? 1;
                      String monthStr = data['month'] ?? 'Jan';
                      int year = now.year;
                      int month = _monthStringToInt(monthStr);
                      DateTime eventDate = DateTime(year, month, day);

                      return {
                        'id': doc.id,
                        'title': data['title'] ?? '',
                        'date': eventDate,
                        'location': data['location'] ?? '',
                        'fullLocation': data['fullLocation'] ?? '',
                        'description': data['description'] ?? '',
                        'category': data['category'] ?? '',
                        'image': data['image'] ?? '',
                        'attendees': List<String>.from(data['attendees'] ?? []),
                      };
                    }).toList();

                    final filteredEvents = events.where((event) {
                      final DateTime eventDate = event['date'];
                      final matchesCategory = selectedCategory == 'UPCOMING'
                          ? eventDate.isAfter(now)
                          : eventDate.isBefore(now);
                      final matchesSearch = searchQuery.isEmpty ||
                          event['title'].toString().toLowerCase().contains(searchQuery.toLowerCase());
                      return matchesCategory && matchesSearch;
                    }).toList()
                      ..sort((a, b) {
                        final DateTime dateA = a['date'];
                        final DateTime dateB = b['date'];
                        return dateA.compareTo(dateB);
                      });

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context),
                          _buildCategoryToggle(),
                          _buildSearchBar(),
                          const SizedBox(height: 30),
                          if (filteredEvents.isEmpty)
                            _buildEmptyState()
                          else
                            _buildEventsList(filteredEvents),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Helpers ----------------
  int _monthStringToInt(String month) {
    switch (month.toLowerCase()) {
      case 'jan': return 1;
      case 'feb': return 2;
      case 'mar': return 3;
      case 'apr': return 4;
      case 'may': return 5;
      case 'jun': return 6;
      case 'jul': return 7;
      case 'aug': return 8;
      case 'sep': return 9;
      case 'oct': return 10;
      case 'nov': return 11;
      case 'dec': return 12;
      default: return 1;
    }
  }

  // ---------------- UI Widgets ----------------
  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.only(right: 11),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: EventHiveColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "Events",
                style: TextStyle(
                  color: EventHiveColors.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: EventHiveColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryToggle() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: EventHiveColors.secondary.withOpacity(0.05),
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedCategory = 'UPCOMING'),
              child: _categoryButton("UPCOMING", selectedCategory == 'UPCOMING'),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedCategory = 'PAST'),
              child: _categoryButton("PAST", selectedCategory == 'PAST'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryButton(String text, bool selected) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: selected ? EventHiveColors.background : Colors.transparent,
        boxShadow: selected
            ? [
          BoxShadow(
            color: EventHiveColors.text.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          )
        ]
            : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: selected ? EventHiveColors.primary : EventHiveColors.secondaryLight,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search events...',
          prefixIcon: Icon(Icons.search, color: EventHiveColors.secondaryLight),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 80),
          Icon(Icons.event_busy, size: 80, color: EventHiveColors.primary),
          const SizedBox(height: 20),
          Text(
            "No Events Found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: EventHiveColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<Map<String, dynamic>> filteredEvents) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: filteredEvents.map((event) => _buildEventCard(event)).toList(),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final DateTime date = event['date'];
    final String formattedDate = DateFormat('MMM dd, y').format(date);
    final bool isPast = date.isBefore(DateTime.now());

    return GestureDetector(
      onTap: () => _showEventDetails(event),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: EventHiveColors.text.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                event['image'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: EventHiveColors.text,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "$formattedDate • ${event['fullLocation']}",
                    style: TextStyle(
                      fontSize: 14,
                      color: EventHiveColors.secondaryLight,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: isPast
                        ? null // 🔒 disable if event is past
                        : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventRegistrationScreen(event: event),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPast
                          ? Colors.grey // grey out past button
                          : EventHiveColors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(isPast ? "Event Ended" : "Register Now"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDetails(Map<String, dynamic> event) {
    final DateTime date = event['date'];
    final String formattedDate = DateFormat('MMM dd').format(date);
    final bool isPast = date.isBefore(DateTime.now());

    showModalBottomSheet(
      context: context,
      backgroundColor: EventHiveColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event['title'] ?? '',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: EventHiveColors.text,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "$formattedDate • ${event['location']}",
                style: TextStyle(
                  fontSize: 16,
                  color: EventHiveColors.secondaryLight,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                event['description'] ?? '',
                style: TextStyle(
                  fontSize: 15,
                  color: EventHiveColors.text,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isPast
                    ? null // 🔒 disable button
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EventRegistrationScreen(event: event),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isPast ? Colors.grey : EventHiveColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: Text(isPast ? "Event Ended" : "Register"),
              ),
            ],
          ),
        );
      },
    );
  }
}
