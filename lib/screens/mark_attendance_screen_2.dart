import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarkAttendanceScreen2 extends ConsumerStatefulWidget {
  const MarkAttendanceScreen2({super.key});

  @override
  ConsumerState<MarkAttendanceScreen2> createState() => _MarkAttendanceScreen2State();
}

class _MarkAttendanceScreen2State extends ConsumerState<MarkAttendanceScreen2> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black26,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.flash_off, color: Colors.white),
            style: IconButton.styleFrom(backgroundColor: Colors.black26),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
            style: IconButton.styleFrom(backgroundColor: Colors.black26),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
           // Camera BG
           Positioned.fill(
            child: Image.network(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuDWr7u9LcEjm7VOETD0VxhUaUBBm2r4Wls64Ov-Y4UOr24xVHYUa7EkkHXX6lxnmMtgiiPrmzMEUaxgPi3imnl0EnJHW-iYanQAFJHKA7hZa0Qnoz_hz2WEHrBV6o18cUAEXw4725_6S-jeN__vy3t-usEHloLbVBDJ-bJjrD3GKunM7zSbXe9QZ-uRRRG3iBrE3nvILXgdm6nGTxzc9VkN-4LgePwxpa3Y9E9VnZWbMRmV-yrDuXHHnMHeBW5yLHJNWg33WVd2PTc",
              fit: BoxFit.cover,
            ),
           ),
           
           // Scanner Overlay
           Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Container(
                   width: 280,
                   height: 280,
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                     borderRadius: BorderRadius.circular(24),
                   ),
                   child: Stack(
                     children: [
                       // Animated Ring
                       AnimatedBuilder(
                         animation: _controller,
                         builder: (context, child) {
                           return Center(
                             child: Container(
                               width: 260 + (_controller.value * 20),
                               height: 260 + (_controller.value * 20),
                               decoration: BoxDecoration(
                                 border: Border.all(
                                   color: theme.colorScheme.primary.withOpacity(1.0 - _controller.value),
                                   width: 2,
                                 ),
                                 borderRadius: BorderRadius.circular(30),
                               ),
                             ),
                           );
                         },
                       ),
                       
                       // Corner Accents
                       Align(alignment: Alignment.topLeft, child: _buildCorner(theme.colorScheme.primary)),
                       Align(alignment: Alignment.topRight, child: Transform.rotate(angle: 1.57, child: _buildCorner(theme.colorScheme.primary))),
                       Align(alignment: Alignment.bottomLeft, child: Transform.rotate(angle: -1.57, child: _buildCorner(theme.colorScheme.primary))),
                       Align(alignment: Alignment.bottomRight, child: Transform.rotate(angle: 3.14, child: _buildCorner(theme.colorScheme.primary))),
                     ],
                   ),
                 ),
                 const SizedBox(height: 32),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                   decoration: BoxDecoration(
                     color: Colors.black54,
                     borderRadius: BorderRadius.circular(30),
                   ),
                   child: const Column(
                     children: [
                       Text("Verifying Identity...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                       SizedBox(height: 4),
                       Text("Please keep your face in the frame", style: TextStyle(color: Colors.white70, fontSize: 12)),
                     ],
                   ),
                 ),
               ],
             ),
           ),
           
           // Bottom Action
           Positioned(
             bottom: 40,
             left: 24,
             right: 24,
             child: OutlinedButton(
               onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  side: const BorderSide(color: Colors.white30),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Enter Student ID Manually", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
             ),
           ),
        ],
      ),
    );
  }
  
  Widget _buildCorner(Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: color, width: 4),
          left: BorderSide(color: color, width: 4),
        ),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16)),
      ),
    );
  }
}
