import 'package:flutter/material.dart';
import '../../widgets/admin_drawer.dart';
import '../../themes/colors.dart'; // Import your EventHiveColors

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _users = [
    {
      'name': 'John Doe',
      'role': 'Admin',
      'status': 'Active',
      'avatar': 'https://i.pravatar.cc/150?img=1'
    },
    {
      'name': 'Jane Smith',
      'role': 'User',
      'status': 'Banned',
      'avatar': 'https://i.pravatar.cc/150?img=2'
    },
    {
      'name': 'Mark Johnson',
      'role': 'Moderator',
      'status': 'Active',
      'avatar': 'https://i.pravatar.cc/150?img=3'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users.where((user) {
      if (_selectedFilter == 'All') return true;
      return user['status'] == _selectedFilter;
    }).toList();

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
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search, color: EventHiveColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              onChanged: (_) {
                setState(() {});
              },
              style: const TextStyle(color: EventHiveColors.text),
            ),
          ),

          // Filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Active'),
                _buildFilterChip('Banned'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // User list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shadowColor: EventHiveColors.primary.withOpacity(0.3),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user['avatar']),
                    ),
                    title: Text(
                      user['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: EventHiveColors.primary,
                      ),
                    ),
                    subtitle: Text(
                      '${user['role']} • ${user['status']}',
                      style: const TextStyle(color: EventHiveColors.secondary),
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: EventHiveColors.accent),
                      onSelected: (value) {
                        // Handle actions
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
            ),
          ),
        ],
      ),

      // Add user button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add new user logic
        },
        backgroundColor: EventHiveColors.accent,
        icon: const Icon(Icons.person_add, color: EventHiveColors.text),
        label: const Text(
          'Add User',
          style: TextStyle(
              color: EventHiveColors.text, fontWeight: FontWeight.bold),
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
}
