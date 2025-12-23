import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherManagementScreen extends ConsumerWidget {
  const TeacherManagementScreen({super.key});

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
        title: const Text("Teacher Management"),
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
                hintText: "Search teachers...",
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
                _buildChip(context, "All Teachers", true),
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
          
          // Teacher List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildTeacherCard(
                  context,
                  "Dr. Sarah Johnson",
                  "sarah.johnson@school.com",
                  "Computer Science",
                  3,
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuDregapwWFizo_NQyT5_HtbKQQTXG-XamiNH3qpqa_nSNtQJSrqNdlwCMzYn3di0WzXXWDz12QHMZ0F2_ZjNLiZ9VE359ORmS_DfXrfJSSTg2nb9gotkDgSrjUkQu5JuzHnkBf_leBuNKpXR_z8OoVvfMnYlN77G9gxRblYmpzXcxCZEffg_rUl2dvOJTxk3NWHyK627ZLT6q8skFwRg1bBIxsZoaufMiuWpuTIZLfYgcorRNabxJZc4gSe6m78HZKcJqQgnQuurvo",
                  true,
                ),
                _buildTeacherCard(
                  context,
                  "Prof. Michael Chen",
                  "michael.chen@school.com",
                  "Data Science",
                  2,
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuAtugTlKnbb4thb3Rc1U2e7bvoTrYLfKdwK9CHmzKT6Gulm3CBwIT6zclUOKTiN1G3Roexcx_vcmdjoY9gCc8YhUz7naz5Y73X2R1zzFqI0phYovfH7l8z2LcRJuxUuWDEbiW6AJXkavzU44G-R7UKN_BImfLQO4Pz2gCb-w9kBDvsw5zBlqmVYf5W2BOXKVsrP2XgoQtbQZXatkp-g6egAMUoWo9qMcV9JAu2Jkh3_yfA7HiQ3Iuo9pcIlwrhk_EbXHrmFacWnHXI",
                  true,
                ),
                _buildTeacherCard(
                  context,
                  "Dr. Emily Davis",
                  "emily.davis@school.com",
                  "Web Development",
                  1,
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuA_DIAklXCa4g-T6AQ80h6DX2xIcIVhnjE0IzBVgXw6qNCSwFkz9jc7SGO_d8qcMYI4MtTLxbfFFif0QAVabk_12wHz_n_Bl38IEcvYeERn1tHJsvwLzHPgC29eFvpLj3gYpP_7s2WkCRgvzNm9SUtDzJtm8YCY6pYCFZstFArxSKYy6zl_Ipvdw-m-MxlE1N29JYSTZu9qFrQoH-YJR_-Os7eLNweek4jMbBlPZBMZ1PeGhMKLH1uycu-c2OyIjKIYvAC0RCfvYfI",
                  false,
                ),
                _buildTeacherCard(
                  context,
                  "Prof. David Wilson",
                  "david.wilson@school.com",
                  "Machine Learning",
                  2,
                  null,
                  true,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTeacherDialog(context),
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

  Widget _buildTeacherCard(
    BuildContext context,
    String name,
    String email,
    String department,
    int classCount,
    String? imageUrl,
    bool isActive,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  image: imageUrl != null
                      ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
                      : null,
                ),
                child: imageUrl == null
                    ? const Center(child: Icon(Icons.person, color: Colors.grey))
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.scaffoldBackgroundColor, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isActive ? "Active" : "Inactive",
                        style: TextStyle(
                          color: isActive ? Colors.green : Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.school, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      department,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.class_, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      "$classCount classes",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit Teacher')),
              const PopupMenuItem(value: 'classes', child: Text('View Classes')),
              const PopupMenuItem(value: 'deactivate', child: Text('Deactivate')),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateTeacherDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Teacher"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Full Name",
                  hintText: "e.g., Dr. John Smith",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1A2633) : Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "john.smith@school.com",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1A2633) : Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Teacher ID",
                  hintText: "T001",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1A2633) : Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1A2633) : Colors.white,
                ),
                items: const [
                  DropdownMenuItem(value: "cs", child: Text("Computer Science")),
                  DropdownMenuItem(value: "eng", child: Text("Engineering")),
                  DropdownMenuItem(value: "math", child: Text("Mathematics")),
                  DropdownMenuItem(value: "physics", child: Text("Physics")),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
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
                const SnackBar(content: Text("Teacher added successfully!")),
              );
            },
            child: const Text("Add Teacher"),
          ),
        ],
      ),
    );
  }
}