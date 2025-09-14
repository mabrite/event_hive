import 'dart:ui';
import 'package:flutter/material.dart';
import '../../themes/colors.dart'; // Make sure this points to your updated colors.dart

class UserEvents extends StatefulWidget {
  const UserEvents({super.key});

  @override
  State<UserEvents> createState() => _UserEventsState();
}

class _UserEventsState extends State<UserEvents> {
  final List<Map<String, String>> events = [
    {
      'title': 'FutureTech Expo 2025',
      'date': 'Aug 18, 2025',
      'location': 'Accra International Conference Centre',
      'description':
      'Explore the future of tech with exhibitions, panels, and workshops.',
      'category': 'Tech',
      'image':
      'https://images.pexels.com/photos/2182970/pexels-photo-2182970.jpeg'
    },
    {
      'title': 'AI & Robotics Summit',
      'date': 'Sep 05, 2025',
      'location': 'KNUST Campus',
      'description':
      'Join top minds in AI and robotics for a powerful knowledge exchange.',
      'category': 'Tech',
      'image':
      'https://images.pexels.com/photos/6693657/pexels-photo-6693657.jpeg'
    },
    {
      'title': 'Digital Culture Festival',
      'date': 'Oct 12, 2025',
      'location': 'La Palm Royal Beach Hotel',
      'description':
      'A celebration of digital art, gaming, culture, and creativity.',
      'category': 'Art',
      'image':
      'https://images.pexels.com/photos/1674752/pexels-photo-1674752.jpeg'
    },
    {
      'title': 'Startup & Innovation Fair',
      'date': 'Nov 03, 2025',
      'location': 'University of Ghana, Legon',
      'description': 'Network with startup founders, innovators, and VCs.',
      'category': 'Business',
      'image':
      'https://images.pexels.com/photos/1181396/pexels-photo-1181396.jpeg'
    },
  ];

  String selectedCategory = 'UPCOMING';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredEvents = events.where((event) {
      final matchesCategory = selectedCategory == 'UPCOMING' ||
          (selectedCategory == 'PAST' && false);
      final matchesSearch = searchQuery.isEmpty ||
          event['title']!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: EventHiveColors.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: EventHiveColors.background,
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 7, bottom: 7, left: 21, right: 21),
            margin: const EdgeInsets.only(bottom: 5),
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    "9:41",
                    style: TextStyle(
                      color: EventHiveColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  width: 16,
                  height: 10,
                  decoration: BoxDecoration(
                    color: EventHiveColors.text,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  width: 15,
                  height: 11,
                  decoration: BoxDecoration(
                    color: EventHiveColors.text,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  width: 24,
                  height: 11,
                  decoration: BoxDecoration(
                    color: EventHiveColors.text,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            width: double.infinity,
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
        ],
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
      margin: const EdgeInsets.only(bottom: 20, left: 40, right: 40),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedCategory = 'UPCOMING'),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: selectedCategory == 'UPCOMING'
                      ? EventHiveColors.background
                      : Colors.transparent,
                  boxShadow: selectedCategory == 'UPCOMING'
                      ? [
                    BoxShadow(
                      color: EventHiveColors.text.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ]
                      : null,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                margin: const EdgeInsets.only(right: 10),
                child: Center(
                  child: Text(
                    "UPCOMING",
                    style: TextStyle(
                      color: selectedCategory == 'UPCOMING'
                          ? EventHiveColors.primary
                          : EventHiveColors.secondaryLight,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedCategory = 'PAST'),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: selectedCategory == 'PAST'
                      ? EventHiveColors.background
                      : Colors.transparent,
                  boxShadow: selectedCategory == 'PAST'
                      ? [
                    BoxShadow(
                      color: EventHiveColors.text.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ]
                      : null,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                margin: const EdgeInsets.only(left: 10),
                child: Center(
                  child: Text(
                    "PAST",
                    style: TextStyle(
                      color: selectedCategory == 'PAST'
                          ? EventHiveColors.primary
                          : EventHiveColors.secondaryLight,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: EventHiveColors.background,
      ),
      child: TextField(
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search events...',
          hintStyle: TextStyle(
            color: EventHiveColors.secondaryLight,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: EventHiveColors.secondaryLight,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        style: TextStyle(
          color: EventHiveColors.text,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 80),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: EventHiveColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy,
              size: 60,
              color: EventHiveColors.primary,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "No Events Found",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: EventHiveColors.text,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            selectedCategory == 'PAST'
                ? "You haven't attended any events yet"
                : "No upcoming events match your search",
            style: TextStyle(
              fontSize: 16,
              color: EventHiveColors.secondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              setState(() {
                searchQuery = '';
                selectedCategory = 'UPCOMING';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: EventHiveColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "Browse All Events",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<Map<String, String>> filteredEvents) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: filteredEvents
            .map(
              (event) => _buildEventCard(event),
        )
            .toList(),
      ),
    );
  }

  Widget _buildEventCard(Map<String, String> event) {
    return GestureDetector(
      onTap: () => _showEventDetails(event),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: EventHiveColors.background,
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
                event['image']!,
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
                    event['title']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: EventHiveColors.text,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${event['date']} • ${event['location']}",
                    style: TextStyle(
                      fontSize: 14,
                      color: EventHiveColors.secondaryLight,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EventHiveColors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Register Now"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDetails(Map<String, String> event) {
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
                event['title']!,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: EventHiveColors.text,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${event['date']} • ${event['location']}",
                style: TextStyle(
                  fontSize: 16,
                  color: EventHiveColors.secondaryLight,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                event['description']!,
                style: TextStyle(
                  fontSize: 15,
                  color: EventHiveColors.text,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: EventHiveColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: const Text("Register"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
