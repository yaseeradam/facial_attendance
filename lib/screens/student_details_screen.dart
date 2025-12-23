import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentDetailsScreen extends ConsumerWidget {
  const StudentDetailsScreen({super.key});

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
        title: const Text("Student Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
             const SizedBox(height: 24),
            // Profile Header
            Column(
              children: [
                Stack(
                  children: [
                     Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.primary, width: 3),
                        image: const DecorationImage(
                          image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuDregapwWFizo_NQyT5_HtbKQQTXG-XamiNH3qpqa_nSNtQJSrqNdlwCMzYn3di0WzXXWDz12QHMZ0F2_ZjNLiZ9VE359ORmS_DfXrfJSSTg2nb9gotkDgSrjUkQu5JuzHnkBf_leBuNKpXR_z8OoVvfMnYlN77G9gxRblYmpzXcxCZEffg_rUl2dvOJTxk3NWHyK627ZLT6q8skFwRg1bBIxsZoaufMiuWpuTIZLfYgcorRNabxJZc4gSe6m78HZKcJqQgnQuurvo"),
                          fit: BoxFit.cover,
                        ),
                      ),
                     ),
                     Positioned(
                       bottom: 0,
                       right: 0,
                       child: Container(
                         padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: theme.scaffoldBackgroundColor, width: 3)),
                         child: const Icon(Icons.check, color: Colors.white, size: 16),
                       ),
                     ),
                  ],
                ),
                const SizedBox(height: 16),
                Text("Jane Doe", style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text("ID: 2023001 • Computer Science", style: TextStyle(color: Colors.grey[500])),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildStatItem(context, "85%", "Attendance", Colors.blue),
                  _buildStatItem(context, "12", "Late", Colors.orange),
                  _buildStatItem(context, "3", "Absent", Colors.red),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Personal Details", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(context, Icons.email_outlined, "Email", "jane.doe@university.edu"),
                        const Divider(height: 24),
                        _buildDetailRow(context, Icons.phone_outlined, "Phone", "+1 (555) 123-4567"),
                        const Divider(height: 24),
                        _buildDetailRow(context, Icons.calendar_today, "Date of Birth", "Mar 15, 2002"),
                        const Divider(height: 24),
                        _buildDetailRow(context, Icons.location_on_outlined, "Address", "123 Campus Dr, Dorm B"),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  Text("Parent/Guardian Info", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                    ),
                    child: Column(
                      children: [
                         _buildDetailRow(context, Icons.person_outline, "Name", "Robert Doe"),
                         const Divider(height: 24),
                         _buildDetailRow(context, Icons.phone_outlined, "Contact", "+1 (555) 987-6543"),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit Profile"),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                            foregroundColor: theme.colorScheme.onBackground,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.face_retouching_natural),
                          label: const Text("Update Face"),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                   const SizedBox(height: 16),
                   SizedBox(
                     width: double.infinity,
                     child: TextButton.icon(
                       onPressed: () {},
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        label: const Text("Delete Student", style: TextStyle(color: Colors.red)),
                         style: TextButton.styleFrom(
                           padding: const EdgeInsets.symmetric(vertical: 16),
                           backgroundColor: Colors.red.withOpacity(0.1),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildStatItem(BuildContext context, String value, String label, Color color) {
     final theme = Theme.of(context);
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: Colors.grey),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
