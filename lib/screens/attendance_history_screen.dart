import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceHistoryScreen extends ConsumerStatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  ConsumerState<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends ConsumerState<AttendanceHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Attendance History"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
               // Search & Filters
               TextField(
                 decoration: InputDecoration(
                   prefixIcon: const Icon(Icons.search),
                   hintText: "Search by Name or ID",
                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                   filled: true,
                   fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                 ),
               ),
               const SizedBox(height: 16),
               SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child: Row(
                   children: [
                     ActionChip(
                       avatar: const Icon(Icons.calendar_month, size: 16, color: Colors.white),
                       label: const Text("This Week", style: TextStyle(color: Colors.white)),
                       backgroundColor: theme.colorScheme.primary,
                       onPressed: () {},
                       side: BorderSide.none,
                       shape: const StadiumBorder(),
                     ),
                     const SizedBox(width: 8),
                     _buildFilterChip(context, "Status", "All"),
                     const SizedBox(width: 8),
                     _buildFilterChip(context, "Department", null),
                   ],
                 ),
               ),
               const SizedBox(height: 24),
               
               // Today Section
               Text("TODAY, OCT 24", style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
               const SizedBox(height: 8),
               _buildHistoryCard(context, "Alex Johnson", "ID: 2023001", "08:30 AM", "Present", Colors.green, "https://lh3.googleusercontent.com/aida-public/AB6AXuBm8gE6vuaDK3Viw1pbCe8cODaDNwfuep1JzFrhccPxldpiVauROI8xNE1MgaQiOMdgrW0PbXsr0HN6CLh1fLkqz2klYuDyFHRo1boPBGdox_yvCvwbHF7E2_9sCnXekCJp6BWp3nO9H4oMeDMq0MEKn7G1ve979ySTJTBW9rv2sQORy4y9FMPtFdEQbln5GWg2lbD1oXCJfavwBCf30beF15o6R_gQPNt6mfSm1w1D-FZogmYwtk4UwNn3XEdn9lIMDlIRkyrchH0"),
               _buildHistoryCard(context, "Sarah Smith", "ID: 2023045", "09:15 AM", "Late", Colors.orange, "https://lh3.googleusercontent.com/aida-public/AB6AXuBT7LaWwG2VC-JWGg6n6Rv9yiaUfo0-uPAAb9QS6irZpxH3Tz7mBSxAcHzv7j1G2N3qTHg3kIPqDtMb3tZGAMX_mEj6G9BxGFkQvMikVeCJSzccjL2udCOdKB24D8ZZGihhA5XbLAsA2jLz0ghoDDHnF1WhRdJLYPtk-6VSaJ-2y6TC3EvO4BZGKerip7YmSSD9iF5nLa3FFigx7jrjCIurWYywk_Mb9TZHGIrnHY_sqL0jOIDHE8y4hPobZMj0D_w22aw92r7hRnU"),

               const SizedBox(height: 24),
               Text("YESTERDAY, OCT 23", style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
               const SizedBox(height: 8),
               _buildHistoryCard(context, "Michael Chen", "ID: 2023012", "08:28 AM", "Present", Colors.green, "https://lh3.googleusercontent.com/aida-public/AB6AXuAKlsgH4o9uRc5YA9mBn6shUtORWY-v-n3muFdLyF-H7JDRGb3aW_PS4VnP59rBwVx9hXtSK02GlStcp6lFc60XVj1YV2so5hFJClW7ROwUbr1pYUEPwBfrov2tVy-u_C887xk1FYehtW_bFU6BTkM3poaotwG0jUF3vZJIUJ42MpqbxQTT8a-bEERZb6BbHvfL-QE6mHpqFCJgYF4oS9EAU3ECmxA0XIKBUPg9PpUvIse4gDXiywFWWQu7coOduzw3sL8u0JpIMt0"),
               _buildHistoryCard(context, "Emily Rose", "ID: 2023088", "-- : --", "Absent", Colors.red, "https://lh3.googleusercontent.com/aida-public/AB6AXuA_zNl1lIfikcmkv8UpMyJRa_IzhAJq9tRCj_H89AaCTyeVZ-0AdHftutzpcokz5-04qaR0teklLo79yKvyd8GNn2clxRBqI1YOW7ZwSPzfUmMHnbDAlMZwMGeC9u0XIqUQ7eTB5xH06LdDhIyE0iCTXMd-VE9uQxhleR8i9NqWY7etJhEZHY8CWRsLMdY03wQQCen2yjOQ6YCeGt9wXdmOGv848rkdCWwUsps3r2bXEcRsxH4_x6oRTuCW3BsCM-4R4_wEKAMUQcs", isAbsent: true),
            ],
          ),
          
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.download, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String? value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Chip(
      label: Text(value != null ? "$label: $value" : label),
      backgroundColor: theme.cardColor,
      side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
      shape: const StadiumBorder(),
    );
  }

  Widget _buildHistoryCard(BuildContext context, String name, String subtext, String time, String status, Color statusColor, String imageUrl, {bool isAbsent = false}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: isAbsent ? 0.8 : 1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover, colorFilter: isAbsent ? const ColorFilter.mode(Colors.grey, BlendMode.saturation) : null),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: theme.cardColor, shape: BoxShape.circle),
                  child: Icon(isAbsent ? Icons.cancel : (status == "Late" ? Icons.schedule : Icons.check_circle), size: 16, color: statusColor),
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
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isAbsent ? Colors.grey : theme.colorScheme.onSurface)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(subtext, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
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
