import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceReportScreen extends ConsumerStatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  ConsumerState<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends ConsumerState<AttendanceReportScreen> {
  String selectedPeriod = 'Today';
  String selectedClass = 'All Classes';

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
          IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.download),
            style: IconButton.styleFrom(
              backgroundColor: theme.cardColor,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(
                bottom: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedPeriod,
                        decoration: InputDecoration(
                          labelText: "Time Period",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1A2633) : Colors.white,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Today', child: Text('Today')),
                          DropdownMenuItem(value: 'This Week', child: Text('This Week')),
                          DropdownMenuItem(value: 'This Month', child: Text('This Month')),
                          DropdownMenuItem(value: 'Custom', child: Text('Custom Range')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedPeriod = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedClass,
                        decoration: InputDecoration(
                          labelText: "Class",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1A2633) : Colors.white,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'All Classes', child: Text('All Classes')),
                          DropdownMenuItem(value: 'CS101', child: Text('Computer Science 101')),
                          DropdownMenuItem(value: 'CS201', child: Text('Data Structures')),
                          DropdownMenuItem(value: 'CS301', child: Text('Web Development')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedClass = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Summary Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    "Total Students",
                    "450",
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    "Present Today",
                    "382",
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    "Attendance Rate",
                    "85%",
                    Icons.trending_up,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // Chart Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Attendance Trend",
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text("Chart Placeholder\n(Integrate with charts_flutter)"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Detailed List
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Detailed Report",
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_list, size: 16),
                          label: const Text("Filter"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildAttendanceItem(
                          context,
                          "Computer Science 101",
                          "CS101",
                          45,
                          38,
                          84.4,
                          Colors.blue,
                        ),
                        _buildAttendanceItem(
                          context,
                          "Data Structures",
                          "CS201",
                          32,
                          29,
                          90.6,
                          Colors.green,
                        ),
                        _buildAttendanceItem(
                          context,
                          "Web Development",
                          "CS301",
                          28,
                          25,
                          89.3,
                          Colors.purple,
                        ),
                        _buildAttendanceItem(
                          context,
                          "Machine Learning",
                          "CS401",
                          35,
                          31,
                          88.6,
                          Colors.orange,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceItem(
    BuildContext context,
    String className,
    String classCode,
    int totalStudents,
    int presentStudents,
    double attendanceRate,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.class_, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  className,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  classCode,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$presentStudents/$totalStudents",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "${attendanceRate.toStringAsFixed(1)}%",
                style: TextStyle(
                  color: attendanceRate >= 85 ? Colors.green : Colors.orange,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}