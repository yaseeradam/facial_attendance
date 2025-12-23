import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarkAttendanceScreen1 extends ConsumerStatefulWidget {
  const MarkAttendanceScreen1({super.key});

  @override
  ConsumerState<MarkAttendanceScreen1> createState() => _MarkAttendanceScreen1State();
}

class _MarkAttendanceScreen1State extends ConsumerState<MarkAttendanceScreen1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Camera Placeholder
          Positioned.fill(
            child: Image.network(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuDWr7u9LcEjm7VOETD0VxhUaUBBm2r4Wls64Ov-Y4UOr24xVHYUa7EkkHXX6lxnmMtgiiPrmzMEUaxgPi3imnl0EnJHW-iYanQAFJHKA7hZa0Qnoz_hz2WEHrBV6o18cUAEXw4725_6S-jeN__vy3t-usEHloLbVBDJ-bJjrD3GKunM7zSbXe9QZ-uRRRG3iBrE3nvILXgdm6nGTxzc9VkN-4LgePwxpa3Y9E9VnZWbMRmV-yrDuXHHnMHeBW5yLHJNWg33WVd2PTc",
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black45, Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        style: IconButton.styleFrom(backgroundColor: Colors.white10),
                      ),
                      const Text(
                        "Mark Attendance",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.help_outline, color: Colors.white),
                        style: IconButton.styleFrom(backgroundColor: Colors.white10),
                      ),
                    ],
                  ),
                ),
                
                // Camera View UI
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Status Badge
                      Positioned(
                        top: 24,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                              SizedBox(width: 8),
                              Text("Face Recognized", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                      
                      // Face Frame
                      SizedBox(
                        width: 280,
                        height: 280,
                        child: Stack(
                          children: [
                            // Corners
                            Align(alignment: Alignment.topLeft, child: _buildCorner(theme.colorScheme.primary, true, true)),
                            Align(alignment: Alignment.topRight, child: _buildCorner(theme.colorScheme.primary, true, false)),
                            Align(alignment: Alignment.bottomLeft, child: _buildCorner(theme.colorScheme.primary, false, true)),
                            Align(alignment: Alignment.bottomRight, child: _buildCorner(theme.colorScheme.primary, false, false)),
                            
                            // Scanner Line
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Positioned(
                                  top: 280 * _controller.value,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary.withOpacity(0.8),
                                      boxShadow: [
                                        BoxShadow(color: theme.colorScheme.primary, blurRadius: 10),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      const Positioned(
                        bottom: 40,
                        child: Text("Hold still for verification", style: TextStyle(color: Colors.white70)),
                      ),
                    ],
                  ),
                ),
                
                // Bottom Sheet
                Container(
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Center(child: Container(width: 48, height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)))),
                      const SizedBox(height: 24),
                      
                      // User Profile
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: theme.colorScheme.primary, width: 2),
                                  image: const DecorationImage(
                                    image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuBBUTJ2nePUsgy-tNanmBmBN9sYyVUPRv0aZ2PnejDPbCOdGJaW-kxpkRxtfF590kYBrhvj7_jGUm19hJKhoA5oWdLJg450hjcmO6aX7I9URse3sfo3uOrxrVBTwHQOpsAvrdvbGb0fnIgmX6ZHFAu7F4z5g0_PgPvx7Arw1oCasVKm--JkWexHSx1rs67VVToPPgb8U_ggWhgxMf_blF1qk06DLvwpSCdVj6hqgCv75MfQxRUf9ibTX9jcZ2oOvTxNmsuZgcINeqg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, shape: BoxShape.circle),
                                  child: const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alice Johnson", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                Text("ID: STU-2023-894", style: TextStyle(color: Colors.grey[500])),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                                child: const Text("Present", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                              const SizedBox(height: 4),
                              Text("Class 10-A", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Stats Grid
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard(context, Icons.schedule, "Time In", "08:45", "AM")),
                          const SizedBox(width: 16),
                          Expanded(child: _buildInfoCard(context, Icons.calendar_today, "Date", "Oct 24", "")),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit, size: 18, color: theme.colorScheme.onSurface),
                                  const SizedBox(width: 8),
                                  Text("Manual Entry", style: TextStyle(color: theme.colorScheme.onSurface)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                backgroundColor: theme.colorScheme.primary,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check, size: 18),
                                  SizedBox(width: 8),
                                  Text("Confirm Attendance"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Color color, bool isTop, bool isLeft) {
    const size = 30.0;
    const thickness = 4.0;
    const radius = 10.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: (isTop && isLeft) ? const Radius.circular(radius) : Radius.zero,
          topRight: (isTop && !isLeft) ? const Radius.circular(radius) : Radius.zero,
          bottomLeft: (!isTop && isLeft) ? const Radius.circular(radius) : Radius.zero,
          bottomRight: (!isTop && !isLeft) ? const Radius.circular(radius) : Radius.zero,
        ),
        border: Border(
          top: isTop ? BorderSide(color: color, width: thickness) : BorderSide.none,
          bottom: !isTop ? BorderSide(color: color, width: thickness) : BorderSide.none,
          left: isLeft ? BorderSide(color: color, width: thickness) : BorderSide.none,
          right: !isLeft ? BorderSide(color: color, width: thickness) : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String label, String value, String suffix) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[50], // background-light
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.0, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: value, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
                if (suffix.isNotEmpty) TextSpan(text: " $suffix", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
