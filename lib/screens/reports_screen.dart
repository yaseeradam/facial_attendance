import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  String _dateFilter = "month";
  String _deptFilter = "cs";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          style: IconButton.styleFrom(
            backgroundColor: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        title: const Text("Attendance Reports"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.ios_share, color: theme.colorScheme.primary),
            style: IconButton.styleFrom(
              backgroundColor: theme.cardColor,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              // Stats Grid
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.4,
                children: [
                  _buildStatCard(context, "Present Today", "850", "+2.1%", Icons.check_circle, true),
                  _buildStatCard(context, "Absent", "42", null, Icons.cancel, false, iconColor: Colors.red),
                  _buildStatCard(context, "Late Arrival", "15", null, Icons.schedule, false, iconColor: Colors.orange),
                  _buildStatCard(context, "Avg. Rate", "94%", "+0.5%", Icons.trending_up, false, iconColor: theme.colorScheme.primary),
                ],
              ),
              const SizedBox(height: 24),
              
              // Filters
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Filters", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: const Text("Reset")),
                ],
              ),
              const SizedBox(height: 8),
              
              // Date Filter
              DropdownButtonFormField<String>(
                initialValue: _dateFilter,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_month),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  filled: true,
                  fillColor: theme.cardColor,
                ),
                items: const [
                  DropdownMenuItem(value: "today", child: Text("Today: Oct 24, 2023")),
                  DropdownMenuItem(value: "week", child: Text("This Week")),
                  DropdownMenuItem(value: "month", child: Text("This Month: October")),
                  DropdownMenuItem(value: "custom", child: Text("Custom Range")),
                ],
                onChanged: (v) => setState(() => _dateFilter = v!),
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _deptFilter,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                         filled: true,
                        fillColor: theme.cardColor,
                      ),
                      items: const [
                        DropdownMenuItem(value: "all", child: Text("All Depts", style: TextStyle(fontSize: 13))),
                        DropdownMenuItem(value: "cs", child: Text("Comp. Sci", style: TextStyle(fontSize: 13))),
                        DropdownMenuItem(value: "math", child: Text("Mathematics", style: TextStyle(fontSize: 13))),
                        DropdownMenuItem(value: "eng", child: Text("Engineering", style: TextStyle(fontSize: 13))),
                      ],
                      onChanged: (v) => setState(() => _deptFilter = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: const Icon(Icons.search, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        filled: true,
                        fillColor: theme.cardColor,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              Text("Detailed Reports", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              // List Items
              _buildReportItem(context, "Alex Johnson", "ID: #CS2023 • 08:02 AM", "Present", Colors.green),
              _buildReportItem(context, "Sarah Williams", "ID: #CS2045 • --:--", "Absent", Colors.red),
              _buildReportItem(context, "Michael Brown", "ID: #CS2088 • 09:15 AM", "Late", Colors.orange),
              _buildReportItem(context, "Emily Davis", "ID: #CS2012 • 08:00 AM", "Present", Colors.green),
              _buildReportItem(context, "David Wilson", "ID: #CS2099 • 08:05 AM", "Present", Colors.green),
              
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("View All Records", style: TextStyle(color: theme.colorScheme.primary)),
                  ],
                ),
              ),
            ],
          ),
          
          // Bottom Export Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    theme.scaffoldBackgroundColor,
                    theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
                    theme.scaffoldBackgroundColor.withValues(alpha: 0),
                  ],
                ),
              ),
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text("Export Report"),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, String? trend, IconData icon, bool isPrimary, {Color? iconColor}) {
    final theme = Theme.of(context);
    final bgColor = isPrimary ? theme.colorScheme.primary : theme.cardColor;
    final textColor = isPrimary ? Colors.white : theme.colorScheme.onSurface;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isPrimary ? [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
        border: !isPrimary ? Border.all(color: Colors.grey.withValues(alpha: 0.1)) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: isPrimary ? Colors.white70 : Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
              Icon(icon, color: iconColor ?? Colors.white70, size: 20),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
              if (trend != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(trend, style: TextStyle(color: isPrimary ? Colors.white : Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(BuildContext context, String name, String subtitle, String status, Color statusColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuD5iivQivTvtM1lD_FZwBnxFl57wFrDQ_7d33zaiTFNjrr1ahOp_JOVCKkqiF2VzG0UFw7TWZQNzxLQpk9VwTIyZ_DAw1EzJd7BaWb0P-oJKVtjBhltq_kbexBeKeJfHpzLy9HSpAEqRyIjcJUQSrPFdCTXKk33jG2P5NMmMrRiIga2UWJ6HTZXei_CixaLT4dYryZsLlHXFt0NtilaaMrFP_0fUCW1lDmw51FhuwXGasFPPzKxzccnpVDvMNk9s2JXU483WIB0Jso"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                 Text(subtitle, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
