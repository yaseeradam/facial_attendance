import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterStudentScreen extends ConsumerStatefulWidget {
  const RegisterStudentScreen({super.key});

  @override
  ConsumerState<RegisterStudentScreen> createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends ConsumerState<RegisterStudentScreen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  String? _selectedClass;

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    super.dispose();
  }

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
            backgroundColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          ),
        ),
        title: const Text("New Registration"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Camera Preview Card
                  Container(
                    width: double.infinity,
                    height: 480, // Approximate height to match aspect ratio
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuDVN-G5NhUScOdUz9evOEFVfV2mPxuxdTIL3LnMfFE6LvdxypfrePZzF1a2klT_zuuNAHBZBb1Div7SxGUoSDg1Q6dJsN25DnWmqNwPwbCrloFzeeKPTIvb0XEfhR21EBKiTZTl_2wnlxGghG34fPHbTTawPTWLOzGZIlqpW3EXLRaa8cmJI_I13o47hA-I31vFrxPVmCUrSRQDU0U7hkXkLNCoUIkAU2yg9YOTrsmaVqGxxVMO9SUdF7M84aOkp_AYctadxX_Qs8c"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                         // Overlay Gradient
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black26, Colors.transparent, Colors.black54],
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            ),
                          ),
                        ),
                        // Frame
                         Center(
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white54, width: 2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                Align(alignment: Alignment.topLeft, child: _buildCorner(theme.colorScheme.primary)),
                                Align(alignment: Alignment.topRight, child: Transform.rotate(angle: 1.57, child: _buildCorner(theme.colorScheme.primary))),
                                Align(alignment: Alignment.bottomLeft, child: Transform.rotate(angle: -1.57, child: _buildCorner(theme.colorScheme.primary))),
                                Align(alignment: Alignment.bottomRight, child: Transform.rotate(angle: 3.14, child: _buildCorner(theme.colorScheme.primary))),
                              ],
                            ),
                          ),
                        ),
                         // Face Detected Badge + Text
                         Positioned(
                           bottom: 24,
                           left: 0,
                           right: 0,
                           child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.sentiment_satisfied, color: Colors.greenAccent, size: 20),
                                    SizedBox(width: 8),
                                    Text("Face Detected", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, shadows: [Shadow(color: Colors.black, blurRadius: 2)])),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text("Position face within the frame", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                           ),
                         ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Retake Button
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt, color: theme.colorScheme.primary),
                    label: Text("Retake Photo", style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[200]!),
                    ),
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Divider(),
                  ),
                  
                  // Form
                  Align(alignment: Alignment.centerLeft, child: Text("Student Details", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
                  const SizedBox(height: 16),
                  
                  _buildTextField(context, "Student ID", "e.g. 2024001", Icons.badge, _idController),
                  const SizedBox(height: 16),
                  _buildTextField(context, "Full Name", "Enter full name", Icons.person, _nameController),
                  const SizedBox(height: 16),
                  
                  // Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Class / Department", style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _selectedClass,
                        items: const [
                          DropdownMenuItem(value: "cs", child: Text("Computer Science")),
                          DropdownMenuItem(value: "eng", child: Text("Engineering")),
                          DropdownMenuItem(value: "arts", child: Text("Arts & Design")),
                          DropdownMenuItem(value: "bus", child: Text("Business Admin")),
                        ],
                        onChanged: (val) => setState(() => _selectedClass = val),
                        decoration: InputDecoration(
                          hintText: "Select Class",
                          prefixIcon: const Icon(Icons.school_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: theme.cardColor,
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
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -2))],
        ),
        child: FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.check_circle_outline),
          label: const Text("Save Student"),
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label, String hint, IconData icon, TextEditingController controller) {
     final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: Icon(icon, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: theme.cardColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCorner(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: color, width: 4),
          left: BorderSide(color: color, width: 4),
        ),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
      ),
    );
  }
}
