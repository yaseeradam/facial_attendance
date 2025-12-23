import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _offlineMode = false;
  bool _faceId = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuB_CObvLVwn3h3IscRNJrSKPvAtAM4PhAX0oN3vCrICB9t8JQzgQAaJb_obCGDzyYzihr5pFuy8sLr1VnPVHvVFOWwthgoreKyNMjCBQG49HhPDj0B_mS8iN9txove_JuQdZ_RZSnKur0Zk3C1bql1Tsu26E23wgGmFPHx33JOfseYDSbAAm3oRttwcjEdVd7l4HUAof0QXh__B89ZsZpK1qX9qFzWzDBM0yyuR6ZsmdNr8mq7D08yDZ143cw0di6YvZQny4p9DGyE"),
                ),
                const SizedBox(height: 12),
                Text("John Doe", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text("Administrator", style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: Colors.green, size: 8),
                      SizedBox(width: 8),
                      Text("Active", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Connectivity
          _buildSectionHeader("Connectivity & Data"),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: _offlineMode,
                  onChanged: (v) => setState(() => _offlineMode = v),
                  title: const Text("Offline Mode", style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text("Use face recognition without internet"),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.wifi_off, color: theme.colorScheme.primary),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.sync, color: Colors.blue),
                  ),
                  title: const Text("Sync Data", style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text("Last synced: 2 mins ago"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Appearance (Added by me for theme switching)
           _buildSectionHeader("Appearance"),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: isDark,
                  onChanged: (v) {
                    ref.read(themeModeProvider.notifier).state = v ? ThemeMode.dark : ThemeMode.light;
                  },
                  title: const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.w600)),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.purple[100], borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.dark_mode, color: Colors.purple),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Security
          _buildSectionHeader("Security"),
          Container(
             decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.lock_reset, color: Colors.orange),
                  ),
                  title: const Text("Change Password", style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _faceId,
                  onChanged: (v) => setState(() => _faceId = v),
                  title: const Text("Face ID Login", style: TextStyle(fontWeight: FontWeight.w600)),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.purple[100], borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.face, color: Colors.purple),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Logout
          ListTile(
            onTap: () {},
            tileColor: theme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Center(child: Text("Log Out", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              "Face Recognition System v2.4.1\nBuild 20231024",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0),
      ),
    );
  }
}
