import 'package:flutter/material.dart';
import '../filters_screen.dart';
import '../notifications_screen.dart';
import '../../themes/colors.dart'; // import your EventHiveColors

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final List<Map<String, String>> eventData = [
    {
      'title': 'Yam Festival',
      'date': '10',
      'month': 'September',
      'attendees': '+20 Going',
      'location': 'Afede Street, HO',
      'image':
      'https://images.pexels.com/photos/1765033/pexels-photo-1765033.jpeg'
    },
    {
      'title': 'Homowo',
      'date': '12',
      'month': 'August',
      'attendees': '+35 Going',
      'location': 'Spintex, Accra',
      'image':
      'https://images.pexels.com/photos/3183197/pexels-photo-3183197.jpeg'
    },
    {
      'title': 'Beach Party',
      'date': '25',
      'month': 'June',
      'attendees': '+100 Going',
      'location': 'Labadi Beach, Accra',
      'image':
      'https://images.pexels.com/photos/2747445/pexels-photo-2747445.jpeg'
    },
    {
      'title': 'Food Festival',
      'date': '8',
      'month': 'Sept',
      'attendees': '+50 Going',
      'location': 'East Legon, Accra',
      'image':
      'https://images.pexels.com/photos/3184199/pexels-photo-3184199.jpeg'
    },
    {
      'title': 'Cultural Night',
      'date': '18',
      'month': 'Oct',
      'attendees': '+70 Going',
      'location': 'Tema, Ghana',
      'image':
      'https://images.pexels.com/photos/4666752/pexels-photo-4666752.jpeg'
    },
    {
      'title': 'STEM Fair',
      'date': '30',
      'month': 'Nov',
      'attendees': '+200 Going',
      'location': 'Accra Mall',
      'image': 'https://images.pexels.com/photos/414886/pexels-photo-414886.jpeg'
    },
  ];

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
                    _buildCategoryChip(
                        'Sports', Icons.sports_soccer, EventHiveColors.accent),
                    _buildCategoryChip(
                        'Music', Icons.music_note, EventHiveColors.primaryLight),
                    _buildCategoryChip(
                        'Food', Icons.restaurant, EventHiveColors.secondary),
                  ],
                ),
              ),
            ),
            // Wrap the main content in Expanded
            Expanded(
              child: Container(
                color: EventHiveColors.background,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader('Upcoming Events'),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 250, // fixed height for horizontal ListView
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: eventData.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final event = eventData[index];
                            return SizedBox(
                              width: screenWidth * 0.45,
                              child: InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('${event['title']} clicked')),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
              Column(
                children: [
                  const Text('Current Location',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Row(
                    children: const [
                      Text('HO, GHANA',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                      Icon(Icons.keyboard_arrow_down,
                          color: Colors.white, size: 16),
                    ],
                  ),
                ],
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

  Widget _buildCategoryChip(String label, IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 17),
            const SizedBox(width: 9),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, String> event) {
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
                        Text(event['date']!,
                            style: const TextStyle(
                                color: EventHiveColors.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        Text(event['month']!,
                            style: const TextStyle(
                                color: EventHiveColors.accent, fontSize: 10)),
                      ],
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
                        event['location']!,
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
        const Text('See All',
            style: TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildInviteSection() {
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
                    style:
                    TextStyle(fontSize: 13, color: EventHiveColors.secondary)),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EventHiveColors.accent,
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 30, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://images.pexels.com/photos/1181357/pexels-photo-1181357.jpeg',
              width: 79,
              height: 61,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('1st May - Sat - 2:00 PM',
                    style: TextStyle(color: EventHiveColors.primary, fontSize: 12)),
                SizedBox(height: 4),
                Text("Women's Leadership Conference",
                    style: TextStyle(
                        color: EventHiveColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Icon(Icons.bookmark_border, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}
