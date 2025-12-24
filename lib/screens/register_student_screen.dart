import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/api_service.dart';

class RegisterStudentScreen extends ConsumerStatefulWidget {
  const RegisterStudentScreen({super.key});

  @override
  ConsumerState<RegisterStudentScreen> createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends ConsumerState<RegisterStudentScreen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  int? _selectedClassId;
  List<Map<String, dynamic>> _classes = [];
  File? _imageFile;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadClasses() async {
    setState(() => _isLoading = true);
    final result = await ApiService.getClasses();
    if (result['success']) {
      setState(() {
        _classes = List<Map<String, dynamic>>.from(result['data'] ?? []);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _capturePhoto() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 85,
    );

    if (photo != null) {
      setState(() {
        _imageFile = File(photo.path);
      });
    }
  }

  Future<void> _saveStudent() async {
    if (_idController.text.isEmpty || _nameController.text.isEmpty || _selectedClassId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture a photo'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSaving = true);

    final result = await ApiService.registerStudent(
      studentId: _idController.text,
      name: _nameController.text,
      classId: _selectedClassId!,
      imageFile: _imageFile!,
    );

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['success'] ? 'Student registered successfully!' : result['error'] ?? 'Failed to register student'),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
        ),
      );

      if (result['success']) {
        Navigator.pop(context);
      }
    }
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
                  GestureDetector(
                    onTap: _capturePhoto,
                    child: Container(
                      width: double.infinity,
                      height: 480,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                        image: _imageFile != null 
                            ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: Stack(
                        children: [
                          if (_imageFile == null)
                            // Empty state
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt, size: 64, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  Text('Tap to capture photo', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                                ],
                              ),
                            ),
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
                          // Status Badge
                          if (_imageFile != null)
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
                                        Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                                        SizedBox(width: 8),
                                        Text("Photo Captured", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Retake Button
                  OutlinedButton.icon(
                    onPressed: _capturePhoto,
                    icon: Icon(Icons.camera_alt, color: theme.colorScheme.primary),
                    label: Text(_imageFile == null ? "Capture Photo" : "Retake Photo", style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
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
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : DropdownButtonFormField<int>(
                              value: _selectedClassId,
                              items: _classes.map((cls) => DropdownMenuItem<int>(
                                value: cls['id'],
                                child: Text(cls['name'] ?? 'Unknown'),
                              )).toList(),
                              onChanged: (val) => setState(() => _selectedClassId = val),
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
          onPressed: _isSaving ? null : _saveStudent,
          icon: _isSaving 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.check_circle_outline),
          label: Text(_isSaving ? "Saving..." : "Save Student"),
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
