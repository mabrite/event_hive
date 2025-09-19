import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/admin_drawer.dart';
import '../../themes/colors.dart';

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      appBar: AppBar(
        title: const Text(
          'User Management',
          style: TextStyle(color: EventHiveColors.text),
        ),
        backgroundColor: EventHiveColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AdminDrawer(),
      body: Column(
        children: [
          // 🔎 Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon:
                const Icon(Icons.search, color: EventHiveColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: EventHiveColors.text),
            ),
          ),

          // 🔘 Filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Active'),
                _buildFilterChip('Removed'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 📋 User list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("users")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text("❌ Error loading users",
                          style: TextStyle(color: Colors.red)));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                // 🔍 Apply search + filter
                final filteredUsers = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['name'] ?? '').toString().toLowerCase();
                  final email = (data['email'] ?? '').toString().toLowerCase();
                  final status = data['status'] ?? 'Active'; // default Active

                  final searchQuery =
                  _searchController.text.toLowerCase().trim();

                  final matchesSearch = name.contains(searchQuery) ||
                      email.contains(searchQuery);

                  final matchesFilter = _selectedFilter == 'All'
                      ? true
                      : status == _selectedFilter;

                  return matchesSearch && matchesFilter;
                }).toList();

                if (filteredUsers.isEmpty) {
                  return const Center(
                    child: Text("🙅 No users found"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final data =
                    filteredUsers[index].data() as Map<String, dynamic>;

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shadowColor: EventHiveColors.primary.withOpacity(0.3),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: data['avatar'] != null && data['avatar'].toString().isNotEmpty
                              ? NetworkImage(data['avatar'])
                              : null,
                          backgroundColor: EventHiveColors.primary,
                          child: (data['avatar'] == null || data['avatar'].toString().isEmpty)
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
                        title: Text(
                          data['name'] ?? "Unknown",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: EventHiveColors.primary,
                          ),
                        ),
                        subtitle: Text(
                          "${data['role'] ?? 'User'} • ${data['status'] ?? 'Active'}",
                          style: const TextStyle(
                              color: EventHiveColors.secondary),
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert,
                              color: EventHiveColors.accent),
                          onSelected: (value) {
                            // TODO: implement actions (edit, delete, etc.)
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'view',
                              child: Text('View Profile'),
                            ),
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit User'),
                            ),
                            const PopupMenuItem(
                              value: 'ban',
                              child: Text('Ban/Unban'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete User'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ➕ Add user button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddUserDialog,
        backgroundColor: EventHiveColors.accent,
        icon: const Icon(Icons.person_add, color: EventHiveColors.text),
        label: const Text(
          'Add User',
          style:
          TextStyle(color: EventHiveColors.text, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: EventHiveColors.primary,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : EventHiveColors.primary,
        fontWeight: FontWeight.w600,
      ),
      side: const BorderSide(color: EventHiveColors.primary),
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
    );
  }

  /// 🟢 Reuse the add-user dialog we created before
  void _showAddUserDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final dobController = TextEditingController();
    String gender = "Male";
    String role = "User";
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> _addUser() async {
              if (nameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  passwordController.text.isEmpty ||
                  dobController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("⚠️ Please fill all fields")),
                );
                return;
              }

              try {
                setState(() => isLoading = true);

                UserCredential userCred =
                await _auth.createUserWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );

                String uid = userCred.user!.uid;

                await _firestore.collection("users").doc(uid).set({
                  "uid": uid,
                  "name": nameController.text.trim(),
                  "email": emailController.text.trim(),
                  "dob": dobController.text.trim(),
                  "gender": gender,
                  "role": role,
                  "status": "Active",
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
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: dobController,
                      decoration: const InputDecoration(
                          labelText: 'Date of Birth (YYYY-MM-DD)',
                          border: OutlineInputBorder()),
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
                          labelText: 'Gender', border: OutlineInputBorder()),
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
                          labelText: 'Role', border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
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
}
