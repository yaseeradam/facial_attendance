import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mark_attendance_screen_1.dart';
import 'register_student_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'admin_profile_setup_screen.dart';
import 'attendance_history_screen.dart';
import 'student_list_screen.dart';
import 'class_management_screen.dart';
import 'teacher_management_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Navigation logic
    switch (index) {
        case 0:
            // Already on Home
            break;
        case 1:
            Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentListScreen()));
            break;
        case 2:
             Navigator.push(context, MaterialPageRoute(builder: (_) => const MarkAttendanceScreen1()));
            break;
        case 3:
             Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceHistoryScreen()));
            break;
        case 4:
             Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminProfileSetupScreen()));
            break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2), width: 2),
                          image: const DecorationImage(
                            image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuBV0Vj6XKh3-jYfldvqMR3w4vv3pvno_ax7Ta2DmB9HIc-ROclXgKBPvClCvz-OcotLuJySA9ZUi1F-1OrXPy2em8XfIK-rGm-Ccjytx5Bbf8r_5ue5TzWBLHplUlD8sflxHFq3fZj8llRPy-bEw99tiwrR7DyQ7jcGtZ7-mqyD_z6-kIQuZ07PPgL1p1_FIDzkVsv9ulnRhLEWD4pcloQrhXrQEraWXjSeXlUuXlTmU81Xi_scbMwVzmPndf3tcOJB8QxsCV7sZpY"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
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
                        Text("Welcome back,", style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
                        Text("Admin User 👋", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                      foregroundColor: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 100),
                children: [
                  // Stats Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text("Overview", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        _buildStatCard(
                          context,
                          icon: Icons.face,
                          iconBg: Colors.white,
                          iconColor: theme.colorScheme.primary,
                          label: "Present Today",
                          value: "85%",
                          trend: "+12%",
                          bg: theme.colorScheme.primary,
                          textColor: Colors.white,
                        ),
                        const SizedBox(width: 16),
                        _buildStatCard(
                          context,
                          icon: Icons.groups,
                          iconBg: Colors.blue[50] ?? Colors.blue.shade50,
                          iconColor: theme.colorScheme.primary,
                          label: "Total Students",
                          value: "450",
                          bg: theme.cardColor,
                          textColor: theme.colorScheme.onSurface,
                          isOutlined: true,
                        ),
                        const SizedBox(width: 16),
                         _buildStatCard(
                          context,
                          icon: Icons.domain,
                          iconBg: Colors.purple[50] ?? Colors.purple.shade50,
                          iconColor: Colors.purple,
                          label: "Departments",
                          value: "12",
                          bg: theme.cardColor,
                          textColor: theme.colorScheme.onSurface,
                          isOutlined: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Quick Actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Quick Actions", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        TextButton(onPressed: () {}, child: const Text("Edit")),
                      ],
                    ),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _buildActionCard(context, "Register New", Icons.person_add, Colors.blue, 
                        () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterStudentScreen()))),
                      _buildActionCard(context, "Scan Face", Icons.center_focus_strong, Colors.green,
                        () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarkAttendanceScreen1()))),
                      _buildActionCard(context, "Classes", Icons.class_, Colors.purple,
                        () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClassManagementScreen()))),
                      _buildActionCard(context, "Teachers", Icons.school, Colors.orange,
                        () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeacherManagementScreen()))),
                      _buildActionCard(context, "Reports", Icons.bar_chart, Colors.teal,
                        () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen()))),
                      _buildActionCard(context, "System", Icons.settings, Colors.grey,
                        () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Recent Activity
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text("Recent Activity", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  _buildActivityItem(context, "Attendance Synced", "Just now", Icons.check_circle, Colors.green),
                  _buildActivityItem(context, "New Student Registered", "2 hours ago", Icons.person_add, Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border(top: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
                _buildNavItem(context, Icons.home, "Home", 0, onTap: () => _onNavTap(0)),
                _buildNavItem(context, Icons.people, "Students", 1, onTap: () => _onNavTap(1)),
                _buildNavItem(context, Icons.center_focus_strong, "Scan", 2, onTap: () => _onNavTap(2)),
                _buildNavItem(context, Icons.history, "History", 3, onTap: () => _onNavTap(3)),
                _buildNavItem(context, Icons.account_circle, "Profile", 4, onTap: () => _onNavTap(4)),
            ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {required IconData icon, required String label, required String value, String? trend, required Color bg, required Color textColor, required Color iconBg, required Color iconColor, bool isOutlined = false}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: isOutlined ? Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!) : null,
        boxShadow: !isOutlined ? [
          BoxShadow(
            color: bg.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ] : null,
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
                  color: isOutlined ? iconBg.withOpacity(isDark ? 0.1 : 1) : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: isOutlined ? iconColor : Colors.white),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(trend, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(label, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String label, IconData icon, MaterialColor color, VoidCallback onTap) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, String title, String time, IconData icon, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(time, style: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index, {VoidCallback? onTap}) {
    final theme = Theme.of(context);
    final isSelected = _currentIndex == index;
    final color = isSelected ? theme.colorScheme.primary : (theme.brightness == Brightness.dark ? Colors.grey[500] : Colors.grey[400]);

    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
