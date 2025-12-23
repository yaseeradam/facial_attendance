import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassManagementScreen extends ConsumerWidget {
  const ClassManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          style: IconButton.styleFrom(
            backgroundColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          ),
        ),
        title: const Text("Class Management"),
        centerTitle: true,
        actions: [
          IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
            style: IconButton.styleFrom(
              backgroundColor: theme.cardColor,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search classes...",
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildChip(context, "All Classes", true),
                const SizedBox(width: 8),
                _buildChip(context, "Active", false),
                const SizedBox(width: 8),
                _buildChip(context, "Computer Science", false),
                const SizedBox(width: 8),
                _buildChip(context, "Engineering", false),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Class List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildClassCard(
                  context,
                  "Computer Science 101",
                  "CS101",
                  "Dr. Sarah Johnson",
                  45,
                  38,
                  Colors.blue,
                ),
                _buildClassCard(
                  context,
                  "Data Structures",
                  "CS201",
                  "Prof. Michael Chen",
                  32,
                  29,
                  Colors.green,
                ),
                _buildClassCard(
                  context,
                  "Web Development",
                  "CS301",
                  "Dr. Emily Davis",
                  28,
                  25,
                  Colors.purple,
                ),
                _buildClassCard(
                  context,
                  "Machine Learning",
                  "CS401",
                  "Prof. David Wilson",
                  35,
                  31,
                  Colors.orange,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateClassDialog(context),
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, bool isSelected) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : theme.colorScheme.onSurface,
        ),
      ),
      backgroundColor: isSelected ? theme.colorScheme.primary : theme.cardColor,
      side: BorderSide.none,
      shape: const StadiumBorder(),
    );
  }

  Widget _buildClassCard(
    BuildContext context,
    String className,
    String classCode,
    String teacher,
    int totalStudents,
    int presentToday,
    Color color,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final attendanceRate = (presentToday / totalStudents * 100).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.class_, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      className,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "$classCode • $teacher",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit Class')),
                  const PopupMenuItem(value: 'students', child: Text('View Students')),
                  const PopupMenuItem(value: 'attendance', child: Text('Attendance Report')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem("Total Students", totalStudents.toString(), Icons.people),
              ),
              Expanded(
                child: _buildStatItem("Present Today", presentToday.toString(), Icons.check_circle),
              ),
              Expanded(
                child: _buildStatItem("Attendance", "$attendanceRate%", Icons.trending_up),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showCreateClassDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Class"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Class Name",
                hintText: "e.g., Computer Science 101",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDark ? const Color(0xFF1A2633) : Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Class Code",
                hintText: "e.g., CS101",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDark ? const Color(0xFF1A2633) : Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Assigned Teacher",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDark ? const Color(0xFF1A2633) : Colors.white,
              ),
              items: const [
                DropdownMenuItem(value: "teacher1", child: Text("Dr. Sarah Johnson")),
                DropdownMenuItem(value: "teacher2", child: Text("Prof. Michael Chen")),
                DropdownMenuItem(value: "teacher3", child: Text("Dr. Emily Davis")),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Class created successfully!")),
              );
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }
}