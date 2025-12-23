import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminProfileSetupScreen extends ConsumerWidget {
  const AdminProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
         leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Profile & Setup"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          // Header
          Container(
            color: theme.cardColor,
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.scaffoldBackgroundColor, width: 4),
                        image: const DecorationImage(
                          image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuC01FIzYyy6AyiNCbgdSXcchN49lDFFP2JILDkymHBnG0txkRWTSPfGo8wa_NoDj7BeESLnz5R83u862VpfUpvGcwcHAqB0xRhFhzrANOy-DEs0VNyr868Vm_jrABFYINODblNs0CDrc2SPm8CA0dptPIS3OASFy-9KQ_d0SrPdaodkTULZRsyv7TPUqgUOwQUT2sDmqmxHayqRUM9vJaHDV5Hw7iBLxhsQdnawc8SXza7ro75EKZ2aRQcQYDf2IcQjXHubIMF8_OM"),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle, border: Border.all(color: theme.cardColor, width: 2)),
                        child: const Icon(Icons.edit, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text("Alex Morgan", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text("Super Administrator", style: theme.textTheme.bodyMedium),
                Text("alex.morgan@company.com", style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, "Security & Access"),
                // Face ID Card
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.face, color: theme.colorScheme.primary),
                                const SizedBox(width: 8),
                                Text("Face ID Access", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Secure your account with biometric login for faster, safer access.",
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add_circle_outline, size: 16),
                              label: const Text("Set up Face ID"),
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 80,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuB9AyY2DrNMuVxJlb4S-S0EGiIGkyMDDgc8rrtzpdxcgbYeXirrkZuHwvItKka76kKvSJ2gvRRP7bz80wAFEWxDNzeW3JNC0m0QCqXIQF9x16PeLq9dNq5hPJp0SUJEkyBStHb-lumDw7tkaEp7D2uiAVCFExT9TZ16JDmAag-b4tZ1dT2M4yBnQM_EniFx5_irdIfmps0AeqbsnMCg1-mckK6mncymsWzTdqTClQYp0ihz5RLhXgGdAC9uXyha4zHICSOHmXjWJfs"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                _buildListItem(context, "Change Password", "Last changed 30 days ago", Icons.lock),
                _buildListItem(context, "Two-Factor Auth", "Enabled via Authenticator App", Icons.shield),
                
                const SizedBox(height: 24),
                _buildHeader(context, "General"),
                _buildListItem(context, "Personal Information", null, Icons.person),
                _buildListItem(context, "Organization Details", null, Icons.domain),
                
                // Notifications Switch
                 Container(
                   margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                        child: Icon(Icons.notifications, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Push Notifications", style: TextStyle(fontWeight: FontWeight.w600)),
                            Text("Alerts for attendance logs", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Switch(value: true, onChanged: (v) {}, activeThumbColor: theme.colorScheme.primary),
                    ],
                  ),
                 ),

                const SizedBox(height: 24),
                _buildHeader(context, "System"),
                _buildListItem(context, "Device Management", "Manage linked face scanners", Icons.settings_system_daydream),
                
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text("Log Out", style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.red.withOpacity(0.3)),
                    backgroundColor: Colors.red.withOpacity(0.05),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                 Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text("Version 1.0.4 (Build 220)", style: theme.textTheme.bodySmall),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildListItem(BuildContext context, String title, String? subtitle, IconData icon) {
     final theme = Theme.of(context);
     final isDark = theme.brightness == Brightness.dark;
     
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!)),
        tileColor: theme.cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: isDark ? Colors.grey[700] : Colors.grey[100], borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: isDark ? Colors.grey[300] : Colors.grey[600]),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
