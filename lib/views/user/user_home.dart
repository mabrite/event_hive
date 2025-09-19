import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:event_hive/views/user/registration_screen.dart';
import '../filters_screen.dart';
import '../notifications_screen.dart';
import '../../themes/colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String _selectedCategory = 'all';
  String _selectedLocation = 'All';
  final Map<String, Color> _categoryColors = {
    'sports': EventHiveColors.accent,
    'music': EventHiveColors.primaryLight,
    'food': EventHiveColors.secondary,
    'festive': EventHiveColors.secondaryLight,
  };

  final List<String> _availableLocations = ['Ho', 'Accra', 'Tema', 'Kumasi', 'Takoradi'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: EventHiveColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(screenWidth),
            Transform.translate(
              offset: const Offset(0, -17),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCategoryChip('Sports', Icons.sports_soccer, 'sports',
                        _selectedCategory == 'sports'
                            ? _categoryColors['sports']!.withOpacity(0.8)
                            : _categoryColors['sports']!),
                    _buildCategoryChip('Music', Icons.music_note, 'music',
                        _selectedCategory == 'music'
                            ? _categoryColors['music']!.withOpacity(0.8)
                            : _categoryColors['music']!),
                    _buildCategoryChip('Food', Icons.restaurant, 'food',
                        _selectedCategory == 'food'
                            ? _categoryColors['food']!.withOpacity(0.8)
                            : _categoryColors['food']!),
                    _buildCategoryChip('Festive', Icons.celebration, 'festive',
                        _selectedCategory == 'festive'
                            ? _categoryColors['festive']!.withOpacity(0.8)
                            : _categoryColors['festive']!),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: EventHiveColors.background,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('events').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'No events yet.\nCheck back later!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: EventHiveColors.secondaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    // Map Firestore docs
                    List<Map<String, dynamic>> events = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final attendeesCount = (data['attendees'] as List<dynamic>?)?.length ?? 0;

                      // Ensure correct date display
                      final date = data['date'] ?? '20';
                      final month = data['month'] ?? 'Sep';
                      final year = data['year'] ?? '2025';

                      return {
                        'id': doc.id,
                        'title': data['title'] ?? 'Untitled Event',
                        'date': date,
                        'month': month,
                        'year': year,
                        'attendees': '+$attendeesCount Going',
                        'location': data['location'] ?? '',
                        'fullLocation': data['fullLocation'] ?? '',
                        'image': data['image'] ?? '',
                        'category': data['category'] ?? 'others',
                      };
                    }).toList();

                    // Apply filters
                    if (_selectedCategory != 'all') {
                      events = events.where((e) => e['category'] == _selectedCategory).toList();
                    }
                    if (_selectedLocation != 'All') {
                      events = events.where((e) => e['location'] == _selectedLocation).toList();
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_selectedCategory != 'all' || _selectedLocation != 'All')
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _buildFilterText(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: EventHiveColors.text),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        _selectedCategory = 'all';
                                        _selectedLocation = 'All';
                                      });
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      padding: const EdgeInsets.all(4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          _sectionHeader('Upcoming Events'),
                          const SizedBox(height: 16),
                          events.isEmpty
                              ? _buildNoEventsFound()
                              : SizedBox(
                            height: 250,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: events.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final event = events[index];
                                return SizedBox(
                                  width: screenWidth * 0.45,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EventRegistrationScreen(event: event),
                                        ),
                                      );
                                    },
                                    child: _buildEventCard(event),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildInviteSection(),
                          const SizedBox(height: 24),
                          _sectionHeader('Nearby You'),
                          const SizedBox(height: 16),
                          _buildNearbyCard(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildFilterText() {
    if (_selectedCategory != 'all' && _selectedLocation != 'All') {
      return '${_selectedCategory.toUpperCase()} EVENTS IN ${_selectedLocation.toUpperCase()}';
    } else if (_selectedCategory != 'all') {
      return '${_selectedCategory.toUpperCase()} EVENTS';
    } else if (_selectedLocation != 'All') {
      return 'EVENTS IN ${_selectedLocation.toUpperCase()}';
    }
    return 'UPCOMING EVENTS';
  }

  Widget _buildHeader(double width) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: EventHiveColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(33),
          bottomRight: Radius.circular(33),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.menu, color: Colors.white, size: 24),
              const Spacer(),
              GestureDetector(
                onTap: () => _showLocationPicker(context),
                child: Column(
                  children: [
                    const Text('Current Location',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Row(
                      children: [
                        Text('$_selectedLocation, GHANA',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                        const Icon(Icons.keyboard_arrow_down,
                            color: Colors.white, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle),
                  child:
                  const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: EventHiveColors.secondaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('Search...',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FiltersScreen(),
                      ),
                    );
                  },
                  child: const Icon(Icons.tune, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, String category, Color color) {
    final isSelected = _selectedCategory == category;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 17),
            const SizedBox(width: 9),
            Text(label,
                style: const TextStyle(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildNoEventsFound() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 50,
            color: EventHiveColors.secondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No events found for this filter',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: EventHiveColors.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new events',
            style: TextStyle(
              fontSize: 14,
              color: EventHiveColors.text.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final category = event['category'];
    final categoryColor = _categoryColors[category];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                Image.network(
                  event['image']!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.2), Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(event['date'] ?? '',
                            style: const TextStyle(
                                color: EventHiveColors.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        Text(event['month'] ?? '',
                            style: const TextStyle(
                                color: EventHiveColors.accent, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
                if (category != null && categoryColor != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event['title']!,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: EventHiveColors.text)),
                const SizedBox(height: 6),
                Text(event['attendees']!,
                    style: const TextStyle(
                        color: EventHiveColors.primary, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: EventHiveColors.secondary),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        event['fullLocation']!,
                        style: const TextStyle(
                            color: EventHiveColors.secondary, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: EventHiveColors.text)),
        const Text('See All', style: TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildInviteSection() {
    final String deepLink = "https://eventshives.com/invite?"
        "referral=${FirebaseAuth.instance.currentUser!.uid}";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [EventHiveColors.primaryLight, EventHiveColors.accentLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Invite your friends',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: EventHiveColors.text)),
                const Text('Get GHS 20 for ticket',
                    style: TextStyle(fontSize: 13, color: EventHiveColors.secondary)),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    SharePlus.instance.share(
                      ShareParams(
                        text: 'Hey! Join EventsHives App using my link: $deepLink',
                        subject: 'Join me at this event!',
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EventHiveColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('INVITE'),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: EventHiveColors.primary, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.people, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyCard() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('location', isEqualTo: _selectedLocation)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(0, 6)),
              ],
            ),
            child: const Center(
              child: Text(
                'No nearby events found',
                style: TextStyle(fontSize: 14, color: EventHiveColors.secondary),
              ),
            ),
          );
        }

        final doc = snapshot.data!.docs.first;
        final data = doc.data() as Map<String, dynamic>;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(0, 6)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    color: EventHiveColors.primary, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.location_on, color: Colors.white, size: 36),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['title'] ?? 'Untitled Event',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                    Text('${data['location'] ?? _selectedLocation}, GH',
                        style: const TextStyle(fontSize: 13, color: EventHiveColors.secondary)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventRegistrationScreen(event: data),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: EventHiveColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Join', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _availableLocations
              .map(
                (loc) => ListTile(
              title: Text(loc),
              onTap: () {
                setState(() {
                  _selectedLocation = loc;
                });
                Navigator.pop(context);
              },
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
