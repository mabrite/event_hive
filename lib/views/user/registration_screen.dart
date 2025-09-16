import 'package:flutter/material.dart';
import '../filters_screen.dart';
import '../notifications_screen.dart';
import '../../themes/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

// Registration Screen Class
class EventRegistrationScreen extends StatefulWidget {
  final Map<String, String> event;

  const EventRegistrationScreen({super.key, required this.event});

  @override
  EventRegistrationScreenState createState() => EventRegistrationScreenState();
}

class EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  int _ticketCount = 1;
  String _selectedPaymentMethod = 'card';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      // Process registration
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Successful'),
            content: Text('You have successfully registered for ${widget.event['title']}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to home
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register for ${widget.event['title']}'),
        backgroundColor: EventHiveColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event summary
            _buildEventSummary(),
            const SizedBox(height: 24),

            // Registration form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attendee Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: EventHiveColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone field
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Ticket quantity
                  const Text(
                    'Number of Tickets',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: EventHiveColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_ticketCount > 1) {
                            setState(() {
                              _ticketCount--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$_ticketCount',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _ticketCount++;
                          });
                        },
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: EventHiveColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Payment method
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: EventHiveColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedPaymentMethod,
                    items: const [
                      DropdownMenuItem(
                        value: 'card',
                        child: Text('Credit/Debit Card'),
                      ),
                      DropdownMenuItem(
                        value: 'mobile',
                        child: Text('Mobile Money'),
                      ),
                      DropdownMenuItem(
                        value: 'bank',
                        child: Text('Bank Transfer'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: EventHiveColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Complete Registration',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.event['image']!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event['title']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: EventHiveColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: EventHiveColors.secondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.event['date']} ${widget.event['month']}',
                      style: const TextStyle(
                        color: EventHiveColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: EventHiveColors.secondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.event['fullLocation']!,
                        style: const TextStyle(
                          color: EventHiveColors.secondary,
                        ),
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
}

class HomeState extends State<Home> {
  final List<Map<String, String>> eventData = [
    {
      'title': 'Yam Festival',
      'date': '10',
      'month': 'September',
      'attendees': '+20 Going',
      'location': 'HO',
      'fullLocation': 'Afede Street, HO',
      'image': 'https://images.pexels.com/photos/1765033/pexels-photo-1765033.jpeg',
      'category': 'food',
    },
    {
      'title': 'Homowo',
      'date': '12',
      'month': 'August',
      'attendees': '+35 Going',
      'location': 'Accra',
      'fullLocation': 'Spintex, Accra',
      'image': 'https://images.pexels.com/photos/3183197/pexels-photo-3183197.jpeg',
      'category': 'food',
    },
    {
      'title': 'Beach Party',
      'date': '25',
      'month': 'June',
      'attendees': '+100 Going',
      'location': 'Accra',
      'fullLocation': 'Labadi Beach, Accra',
      'image': 'https://images.pexels.com/photos/2747445/pexels-photo-2747445.jpeg',
      'category': 'music',
    },
    {
      'title': 'Food Festival',
      'date': '8',
      'month': 'Sept',
      'attendees': '+50 Going',
      'location': 'Accra',
      'fullLocation': 'East Legon, Accra',
      'image': 'https://images.pexels.com/photos/3184199/pexels-photo-3184199.jpeg',
      'category': 'food',
    },
    {
      'title': 'Cultural Night',
      'date': '18',
      'month': 'Oct',
      'attendees': '+70 Going',
      'location': 'Tema',
      'fullLocation': 'Tema, Ghana',
      'image': 'https://images.pexels.com/photos/4666752/pexels-photo-4666752.jpeg',
      'category': 'music',
    },
    {
      'title': 'STEM Fair',
      'date': '30',
      'month': 'Nov',
      'attendees': '+200 Going',
      'location': 'Accra',
      'fullLocation': 'Accra Mall',
      'image': 'https://images.pexels.com/photos/414886/pexels-photo-414886.jpeg',
      'category': 'sports',
    },
    {
      'title': 'Football Tournament',
      'date': '15',
      'month': 'July',
      'attendees': '+150 Going',
      'location': 'Accra',
      'fullLocation': 'Accra Sports Stadium',
      'image': 'https://images.pexels.com/photos/46798/the-ball-stadion-football-the-pitch-46798.jpeg',
      'category': 'sports',
    },
    {
      'title': 'Jazz Concert',
      'date': '22',
      'month': 'August',
      'attendees': '+80 Going',
      'location': 'Accra',
      'fullLocation': 'National Theatre, Accra',
      'image': 'https://images.pexels.com/photos/167491/pexels-photo-167491.jpeg',
      'category': 'music',
    },
    {
      'title': 'Basketball Championship',
      'date': '5',
      'month': 'October',
      'attendees': '+120 Going',
      'location': 'Accra',
      'fullLocation': 'Bukom Boxing Arena',
      'image': 'https://images.pexels.com/photos/1752757/pexels-photo-1752757.jpeg',
      'category': 'sports',
    },
    {
      'title': 'Volta Music Festival',
      'date': '18',
      'month': 'November',
      'attendees': '+45 Going',
      'location': 'HO',
      'fullLocation': 'Volta Serene, HO',
      'image': 'https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg',
      'category': 'music',
    },
    {
      'title': 'Ho Sports Day',
      'date': '7',
      'month': 'December',
      'attendees': '+80 Going',
      'location': 'HO',
      'fullLocation': 'Ho Sports Stadium',
      'image': 'https://images.pexels.com/photos/863988/pexels-photo-863988.jpeg',
      'category': 'sports',
    },
  ];

  String _selectedCategory = 'all';
  String _selectedLocation = 'HO'; // Default location
  final Map<String, Color> _categoryColors = {
    'sports': EventHiveColors.accent,
    'music': EventHiveColors.primaryLight,
    'food': EventHiveColors.secondary,
  };

  final List<String> _availableLocations = ['HO', 'Accra', 'Tema', 'Kumasi', 'Takoradi'];

  List<Map<String, String>> get _filteredEvents {
    List<Map<String, String>> filtered = eventData;

    // Filter by category
    if (_selectedCategory != 'all') {
      filtered = filtered.where((event) => event['category'] == _selectedCategory).toList();
    }

    // Filter by location
    if (_selectedLocation != 'All') {
      filtered = filtered.where((event) => event['location'] == _selectedLocation).toList();
    }

    return filtered;
  }

  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: EventHiveColors.text,
                ),
              ),
              const SizedBox(height: 16),
              ..._availableLocations.map((location) {
                return ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: EventHiveColors.primary,
                  ),
                  title: Text(
                    location,
                    style: TextStyle(
                      fontWeight: _selectedLocation == location
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _selectedLocation == location
                          ? EventHiveColors.primary
                          : EventHiveColors.text,
                    ),
                  ),
                  trailing: _selectedLocation == location
                      ? Icon(Icons.check, color: EventHiveColors.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedLocation = location;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(
                  Icons.public,
                  color: EventHiveColors.secondary,
                ),
                title: const Text(
                  'All Locations',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: EventHiveColors.secondary,
                  ),
                ),
                trailing: _selectedLocation == 'All'
                    ? Icon(Icons.check, color: EventHiveColors.secondary)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedLocation = 'All';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Navigation method to registration screen
  void _navigateToRegistration(Map<String, String> event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventRegistrationScreen(event: event),
      ),
    );
  }

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
                      'Sports',
                      Icons.sports_soccer,
                      'sports',
                      _selectedCategory == 'sports'
                          ? _categoryColors['sports']!.withOpacity(0.8)
                          : _categoryColors['sports']!,
                    ),
                    _buildCategoryChip(
                      'Music',
                      Icons.music_note,
                      'music',
                      _selectedCategory == 'music'
                          ? _categoryColors['music']!.withOpacity(0.8)
                          : _categoryColors['music']!,
                    ),
                    _buildCategoryChip(
                      'Food',
                      Icons.restaurant,
                      'food',
                      _selectedCategory == 'food'
                          ? _categoryColors['food']!.withOpacity(0.8)
                          : _categoryColors['food']!,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: EventHiveColors.background,
                child: SingleChildScrollView(
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
                                    color: EventHiveColors.text,
                                  ),
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
                      _filteredEvents.isEmpty
                          ? _buildNoEventsFound()
                          : SizedBox(
                        height: 250,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filteredEvents.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final event = _filteredEvents[index];
                            return SizedBox(
                              width: screenWidth * 0.45,
                              child: InkWell(
                                onTap: () {
                                  _navigateToRegistration(event);
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
          border: isSelected
              ? Border.all(color: Colors.white, width: 2)
              : null,
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
            _buildNoEventsMessage(),
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

  String _buildNoEventsMessage() {
    if (_selectedCategory != 'all' && _selectedLocation != 'All') {
      return 'No ${_selectedCategory} events found in $_selectedLocation';
    } else if (_selectedCategory != 'all') {
      return 'No ${_selectedCategory} events found';
    } else if (_selectedLocation != 'All') {
      return 'No events found in $_selectedLocation';
    }
    return 'No events found';
  }

  Widget _buildEventCard(Map<String, String> event) {
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
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 120,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
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