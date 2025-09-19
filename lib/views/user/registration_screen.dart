import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../themes/colors.dart';

class EventRegistrationScreen extends StatefulWidget {
  final Map<String, dynamic> event;

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
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Helper to convert month string to int
  int _monthStringToInt(String month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months.indexOf(month) + 1; // DateTime months start at 1
  }

  // Send email via backend endpoint
  Future<void> _sendEmail({
    required String name,
    required String email,
    required String eventTitle,
    required String eventDate,
    required String eventLocation,
    required int tickets,
    required String eventLink,
  }) async {
    final uri = Uri.parse('https://sunburnchatapi.onrender.com/event_hives_send_email');
    final body = jsonEncode({
      "name": name,
      "email": email,
      "event_title": eventTitle,
      "event_date": eventDate,
      "event_location": eventLocation,
      "tickets": tickets.toString(),
      "event_link": eventLink,
    });

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode != 200) {
        debugPrint('Email sending failed: ${response.body}');
      } else {
        debugPrint('Email sent successfully.');
      }
    } catch (e) {
      debugPrint('Error sending email: $e');
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please log in to register")),
        );
        setState(() => _isLoading = false);
        return;
      }

      final eventId = widget.event['id'];
      final eventRef =
      FirebaseFirestore.instance.collection('events').doc(eventId);

      // Add current user UID to attendees
      await eventRef.update({
        'attendees': FieldValue.arrayUnion([user.uid]),
      });

      // Save registration record
      await FirebaseFirestore.instance.collection('registrations').add({
        'userId': user.uid,
        'eventId': eventId,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'tickets': _ticketCount,
        'paymentMethod': _selectedPaymentMethod,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Build formatted date
      final eventDate = DateTime(
        int.tryParse(widget.event['year'] ?? '2025') ?? 2025,
        _monthStringToInt(widget.event['month'] ?? 'Jan'),
        int.tryParse(widget.event['day'] ?? '1') ?? 1,
      );
      final formattedDate = DateFormat('MMM dd, y').format(eventDate);

      // Send email
      await _sendEmail(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        eventTitle: widget.event['title'] ?? '',
        eventDate: formattedDate,
        eventLocation: widget.event['fullLocation'] ?? '',
        tickets: _ticketCount,
        eventLink: widget.event['link'] ?? '',
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Registration Successful'),
              content: Text(
                  'You have successfully registered for ${widget.event['title']}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Return to events
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error registering: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildEventSummary(Map<String, dynamic> event) {
    DateTime? eventDate;
    try {
      final day = int.tryParse(event['day'] ?? '1') ?? 1;
      final month = _monthStringToInt(event['month'] ?? 'Jan');
      final year = int.tryParse(event['year'] ?? '2025') ?? 2025;
      eventDate = DateTime(year, month, day);
    } catch (_) {
      eventDate = null;
    }

    final String formattedDate =
    eventDate != null ? DateFormat('MMM dd, y').format(eventDate) : 'TBA';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              event['image'] ?? '',
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
                  event['title'] ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: EventHiveColors.text),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: EventHiveColors.secondary),
                    const SizedBox(width: 8),
                    Text(formattedDate,
                        style: const TextStyle(color: EventHiveColors.secondary)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: EventHiveColors.secondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event['fullLocation'] ?? '',
                        style: const TextStyle(color: EventHiveColors.secondary),
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
            _buildEventSummary(widget.event),
            const SizedBox(height: 24),
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
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter email';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Enter valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Enter phone' : null,
                  ),
                  const SizedBox(height: 24),
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
                          if (_ticketCount > 1) setState(() => _ticketCount--);
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$_ticketCount',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () => setState(() => _ticketCount++),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    value: _selectedPaymentMethod,
                    items: const [
                      DropdownMenuItem(
                          value: 'card', child: Text('Credit/Debit Card')),
                      DropdownMenuItem(
                          value: 'mobile', child: Text('Mobile Money')),
                      DropdownMenuItem(
                          value: 'bank', child: Text('Bank Transfer')),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedPaymentMethod = value!),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: EventHiveColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Complete Registration'),
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
}