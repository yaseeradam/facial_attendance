import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'student_details_screen.dart';

class StudentListScreen extends ConsumerWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: false,
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text("Students", style: TextStyle(fontWeight: FontWeight.bold)),
                     Text("Manage face data and attendance", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                  ],
                ),
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
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search by name, ID, or class...",
                        filled: true,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                 child: SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   child: Row(
                     children: [
                       _buildChip(context, "All Students", true),
                       const SizedBox(width: 8),
                       _buildChip(context, "Registered", false),
                       const SizedBox(width: 8),
                       _buildChip(context, "Pending Face Data", false),
                       const SizedBox(width: 8),
                       _buildChip(context, "Class A", false),
                     ],
                   ),
                 ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildStudentCard(context, "Jane Doe", "ID: 2023001 • Class 3A", "Registered", Colors.blue, "https://lh3.googleusercontent.com/aida-public/AB6AXuDregapwWFizo_NQyT5_HtbKQQTXG-XamiNH3qpqa_nSNtQJSrqNdlwCMzYn3di0WzXXWDz12QHMZ0F2_ZjNLiZ9VE359ORmS_DfXrfJSSTg2nb9gotkDgSrjUkQu5JuzHnkBf_leBuNKpXR_z8OoVvfMnYlN77G9gxRblYmpzXcxCZEffg_rUl2dvOJTxk3NWHyK627ZLT6q8skFwRg1bBIxsZoaufMiuWpuTIZLfYgcorRNabxJZc4gSe6m78HZKcJqQgnQuurvo"),
                  _buildStudentCard(context, "John Smith", "ID: 2023002 • Class 3A", "Pending", Colors.orange, null),
                  _buildStudentCard(context, "Robert Fox", "ID: 2023045 • Class 3B", "Registered", Colors.blue, "https://lh3.googleusercontent.com/aida-public/AB6AXuAtugTlKnbb4thb3Rc1U2e7bvoTrYLfKdwK9CHmzKT6Gulm3CBwIT6zclUOKTiN1G3Roexcx_vcmdjoY9gCc8YhUz7naz5Y73X2R1zzFqI0phYovfH7l8z2LcRJuxUuWDEbiW6AJXkavzU44G-R7UKN_BImfLQO4Pz2gCb-w9kBDvsw5zBlqmVYf5W2BOXKVsrP2XgoQtbQZXatkp-g6egAMUoWo9qMcV9JAu2Jkh3_yfA7HiQ3Iuo9pcIlwrhk_EbXHrmFacWnHXI"),
                  _buildStudentCard(context, "Esther Howard", "ID: 2023012 • Class 3A", "Registered", Colors.blue, "https://lh3.googleusercontent.com/aida-public/AB6AXuA_DIAklXCa4g-T6AQ80h6DX2xIcIVhnjE0IzBVgXw6qNCSwFkz9jc7SGO_d8qcMYI4MtTLxbfFFif0QAVabk_12wHz_n_Bl38IEcvYeERn1tHJsvwLzHPgC29eFvpLj3gYpP_7s2WkCRgvzNm9SUtDzJtm8YCY6pYCFZstFArxSKYy6zl_Ipvdw-m-MxlE1N29JYSTZu9qFrQoH-YJR_-Os7eLNweek4jMbBlPZBMZ1PeGhMKLH1uycu-c2OyIjKIYvAC0RCfvYfI"),
                  _buildStudentCard(context, "Albert Flores", "ID: 2023088 • Class 3C", "Pending", Colors.orange, null),
                  const SizedBox(height: 100),
                ]),
              ),
            ],
          ),
          
          Positioned(
            bottom: 90,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, bool isSelected) {
     final theme = Theme.of(context);
    return Chip(
      label: Text(label, style: TextStyle(color: isSelected ? Colors.white : theme.colorScheme.onSurface)),
      backgroundColor: isSelected ? theme.colorScheme.primary : theme.cardColor,
      side: BorderSide.none,
      shape: const StadiumBorder(),
    ); 
  }

  Widget _buildStudentCard(BuildContext context, String name, String subtitle, String status, Color statusColor, String? imageUrl) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StudentDetailsScreen()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[100]!),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
                image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover) : null,
              ),
              child: imageUrl == null ? const Center(child: Icon(Icons.person, color: Colors.grey)) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
