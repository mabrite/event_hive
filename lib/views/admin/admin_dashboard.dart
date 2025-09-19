import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;
import '../../widgets/admin_drawer.dart';
import '../../themes/colors.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  Animation<double>? _pulseAnimation;
  Animation<double>? _rotateAnimation;

  final FirebaseAuth _auth = FirebaseAuth.instance;


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotateController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: _buildModernAppBar(),
      drawer: const AdminDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              EventHiveColors.background,
              EventHiveColors.background,
              EventHiveColors.primaryLight.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 24),
              _buildAnalyticsGrid(),
              const SizedBox(height: 24),
              _buildQuickActionsRow(),
              const SizedBox(height: 24),
              _buildSectionTitle("Recent Activity"),
              const SizedBox(height: 12),
              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  /// Modern AppBar
  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: EventHiveColors.primary),
      title: Row(
        children: [
          if (_rotateAnimation != null)
            AnimatedBuilder(
              animation: _rotateAnimation!,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotateAnimation!.value,
                  child: const Icon(Icons.dashboard,
                      color: EventHiveColors.primary),
                );
              },
            ),
          const SizedBox(width: 12),
          const Text(
            "Admin Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: EventHiveColors.text,
            ),
          ),
        ],
      ),
      actions: const [SizedBox(width: 8)],
    );
  }

  /// Welcome Card
  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome Back, Admin!",
                  style: TextStyle(
                    color: EventHiveColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Dashboard Overview",
                  style: TextStyle(
                    color: EventHiveColors.text,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "All systems running smoothly ✅",
                  style: TextStyle(
                    color: EventHiveColors.secondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: EventHiveColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Last login: Today at 09:42 AM",
                    style: TextStyle(
                      color: EventHiveColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_pulseAnimation != null)
            ScaleTransition(
              scale: _pulseAnimation!,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: EventHiveColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: EventHiveColors.primary,
                  size: 36,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Analytics Grid (with safe handling for Timestamp/String)
  Widget _buildAnalyticsGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("users").snapshots(),
      builder: (context, userSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection("events").snapshots(),
          builder: (context, eventSnapshot) {
            if (!userSnapshot.hasData || !eventSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final users = userSnapshot.data!.docs;
            final events = eventSnapshot.data!.docs;

            final userCount = users.length;
            final eventCount = events.length;

            // Compute upcoming and past events using timestamp
            int upcomingEvents = events.where((doc) {
              final ts = doc['timestamp'] as Timestamp?;
              if (ts == null) return false;
              final eventDate = ts.toDate();
              return eventDate.isAfter(DateTime.now());
            }).length;

            int pastEvents = events.where((doc) {
              final ts = doc['timestamp'] as Timestamp?;
              if (ts == null) return false;
              final eventDate = ts.toDate();
              return eventDate.isBefore(DateTime.now());
            }).length;

            final stats = [
              {
                "title": "Total Users",
                "value": userCount.toString(),
                "change": "+12%",
                "icon": Icons.people_outline,
                "color": EventHiveColors.primary
              },
              {
                "title": "Total Events",
                "value": eventCount.toString(),
                "change": "+5%",
                "icon": Icons.event,
                "color": EventHiveColors.secondary
              },
              {
                "title": "Upcoming Events",
                "value": upcomingEvents.toString(),
                "change": "+8%",
                "icon": Icons.upcoming,
                "color": EventHiveColors.accent
              },
              {
                "title": "Past Events",
                "value": pastEvents.toString(),
                "change": "-2%",
                "icon": Icons.history,
                "color": EventHiveColors.secondaryLight
              },
            ];

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stats.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, i) {
                final stat = stats[i];
                final isPositive = (stat["change"] as String).contains('+');

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (stat["color"] as Color).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(stat["icon"] as IconData,
                                color: stat["color"] as Color, size: 20),
                          ),
                          Text(
                            stat["change"] as String,
                            style: TextStyle(
                              color: isPositive ? Colors.green : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        stat["value"] as String,
                        style: TextStyle(
                          color: stat["color"] as Color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stat["title"] as String,
                        style: TextStyle(
                          color: EventHiveColors.text.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  /// Quick Actions
  Widget _buildQuickActionsRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Quick Actions"),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickAction("Add User", Icons.person_add,
                  EventHiveColors.primary, _showAddUserDialog),
              const SizedBox(width: 12),
              _buildQuickAction("Create Event", Icons.add_circle,
                  EventHiveColors.accent, _showCreateEventDialog),
              const SizedBox(width: 12),
              _buildQuickAction("Remove User", Icons.person_remove, Colors.red,
                  _showRemoveUserDialog),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(
      String title, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Recent Activity
  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("notifications")
            // .where("userId", isEqualTo: _auth.currentUser!.uid) // user-specific
            .orderBy("time", descending: true) // latest first
            .limit(3)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text("No recent activity.");
          }

          final notifications = snapshot.data!.docs;

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final notif = notifications[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: Icon(
                  notif["type"] == "event"
                      ? Icons.event
                      : Icons.notifications, // type-based icon
                  color: notif["isRead"] == true ? Colors.grey : Colors.blue,
                ),
                title: Text(
                  notif["title"] ?? "No Title",
                  style: TextStyle(
                    fontWeight: notif["isRead"] == true
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
                subtitle: Text(notif["message"] ?? ""),
                trailing: Text(
                  notif["time"] != null
                      ? (notif["time"] as Timestamp)
                      .toDate()
                      .toLocal()
                      .toString()
                      .substring(0, 16) // yyyy-MM-dd HH:mm
                      : "",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () async {
                  // Mark as read when tapped
                  await FirebaseFirestore.instance
                      .collection("notifications")
                      .doc(notifications[index].id)
                      .update({"isRead": true});
                },
              );
            },
          );
        },
      ),
    );
  }

  /// Add User Dialog
  void _showAddUserDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final dobController = TextEditingController();
    String gender = "Male"; // default
    String role = "User";
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> _pickDate() async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000, 1, 1),
                firstDate: DateTime(1900),
                lastDate: now,
              );
              if (picked != null) {
                dobController.text = picked.toIso8601String().split("T")[0];
                // saves YYYY-MM-DD
              }
            }

            Future<void> _addUser() async {
              if (nameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  passwordController.text.isEmpty ||
                  dobController.text.isEmpty ||
                  gender.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("⚠️ Please fill all fields")),
                );
                return;
              }

              try {
                setState(() => isLoading = true);

                // ✅ Create Firebase Auth account
                UserCredential userCred =
                await _auth.createUserWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );

                String uid = userCred.user!.uid;

                // ✅ Save user profile in Firestore
                await _firestore.collection("users").doc(uid).set({
                  "uid": uid,
                  "name": nameController.text.trim(),
                  "email": emailController.text.trim(),
                  "dob": dobController.text.trim(), // string (YYYY-MM-DD)
                  "gender": gender,
                  "role": role,
                  "createdAt": FieldValue.serverTimestamp(),
                });

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("✅ $role created successfully")),
                  );
                }
              } on FirebaseAuthException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("❌ ${e.message}")),
                );
              } finally {
                setState(() => isLoading = false);
              }
            }

            return AlertDialog(
              title: const Text('Add New User'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dobController,
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: gender,
                      items: ['Male', 'Female', 'Other']
                          .map((g) =>
                          DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (val) => setState(() => gender = val!),
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: role,
                      items: ['User', 'Organizer', 'Admin']
                          .map((r) =>
                          DropdownMenuItem(value: r, child: Text(r)))
                          .toList(),
                      onChanged: (val) => setState(() => role = val!),
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : _addUser,
                  child: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text('Add User'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Remove User Dialog
  void _showRemoveUserDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final docs = snapshot.data!.docs;
            String? selectedId;

            return AlertDialog(
              title: const Text("Remove User"),
              content: DropdownButtonFormField<String>(
                value: selectedId,
                items: docs
                    .map((d) => DropdownMenuItem(
                    value: d.id,
                    child: Text("${d["name"]} (${d["email"]})")))
                    .toList(),
                onChanged: (val) => selectedId = val,
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedId != null) {
                      await _firestore.collection("users").doc(selectedId).delete();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Remove"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Create Event Dialog (structured like OrganizerEvents)
  void _showCreateEventDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    final fullLocationController = TextEditingController();

    DateTime? selectedDate;
    String? selectedCategory;
    File? pickedImageFile;
    String? imageUrl;

    final categories = ['sports', 'music', 'food', 'tech', 'education', 'art', 'festive'];

    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          Future<void> pickDate() async {
            final now = DateTime.now();
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? now,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setDialogState(() => selectedDate = picked);
            }
          }

          Future<void> pickImage() async {
            final picker = ImagePicker();
            final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
            if (picked != null) {
              setDialogState(() {
                pickedImageFile = File(picked.path);
              });
            }
          }

          Future<void> createEvent() async {
            if (titleController.text.trim().isEmpty ||
                selectedDate == null ||
                selectedCategory == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("⚠️ Please fill all required fields")),
              );
              return;
            }

            setDialogState(() => isLoading = true);

            try {
              // ✅ Upload image if picked
              if (pickedImageFile != null) {
                final ref = FirebaseStorage.instance
                    .ref()
                    .child('event_images/${DateTime.now().millisecondsSinceEpoch}');
                await ref.putFile(pickedImageFile!);
                imageUrl = await ref.getDownloadURL();
              }

              const monthNames = [
                'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
              ];
              String month = monthNames[selectedDate!.month - 1];

              // ✅ Save to Firestore
              final newDoc = await _firestore.collection("events").add({
                "title": titleController.text.trim(),
                "description": descriptionController.text.trim(),
                "date": selectedDate!.day.toString(),
                "month": month,
                "year": selectedDate!.year.toString(),
                "location": locationController.text.trim(),
                "fullLocation": fullLocationController.text.trim(),
                'attendees': [],
                "category": selectedCategory,
                "image": imageUrl ?? "",
                "registrations": 0,
                "userId": _auth.currentUser?.uid,
                "timestamp": selectedDate,
                "createdAt": FieldValue.serverTimestamp(),
                "updatedAt": FieldValue.serverTimestamp(),
              });

              // ✅ Send notification
              await _firestore.collection("notifications").add({
                "title": "New Event: ${titleController.text.trim()}",
                "message": "${titleController.text.trim()} is happening at ${locationController.text.trim()}",
                "time": FieldValue.serverTimestamp(),
                "type": "event",
                "isRead": false,
                "priority": "high",
                "eventId": newDoc.id,
                "userId": _auth.currentUser?.uid,
              });

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✨ Event created successfully!")),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("❌ Failed: $e")),
              );
            } finally {
              setDialogState(() => isLoading = false);
            }
          }

          return AlertDialog(
            title: const Text("Create Event"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Event Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: pickDate,
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: selectedDate != null
                              ? "Date: ${selectedDate!.toLocal().toString().split(" ")[0]}"
                              : "Pick Event Date",
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: "Location",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: fullLocationController,
                    decoration: const InputDecoration(
                      labelText: "Full Location",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    hint: const Text("Select Category"),
                    items: categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setDialogState(() => selectedCategory = val),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Category",
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text("Pick Event Image"),
                  ),
                  if (pickedImageFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Image.file(
                        pickedImageFile!,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  else if (imageUrl != null && imageUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Image.network(
                        imageUrl!,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : createEvent,
                child: isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text("Create"),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: EventHiveColors.text,
          fontWeight: FontWeight.w600,
          fontSize: 16),
    );
  }
}
