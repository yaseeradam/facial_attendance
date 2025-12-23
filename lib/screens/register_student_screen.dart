import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';
import '../services/validation_service.dart';
import '../services/api_service.dart';
import '../widgets/common_widgets.dart';
import 'dart:io';

class RegisterStudentScreen extends ConsumerStatefulWidget {
  const RegisterStudentScreen({super.key});

  @override
  ConsumerState<RegisterStudentScreen> createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends ConsumerState<RegisterStudentScreen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  String? _selectedClass;
  File? _capturedImage;
  bool _isCameraInitialized = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final success = await CameraService.initialize();
    setState(() => _isCameraInitialized = success);
  }

  Future<void> _takePicture() async {
    final image = await CameraService.takePicture();
    if (image != null) {
      setState(() => _capturedImage = image);
    }
  }

  Future<void> _registerStudent() async {
    final idError = ValidationService.validateStudentId(_idController.text);
    final nameError = ValidationService.validateName(_nameController.text);
    final classError = ValidationService.validateRequired(_selectedClass, 'Class');
    
    if (idError != null || nameError != null || classError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(idError ?? nameError ?? classError!), backgroundColor: Colors.red),
      );
      return;
    }

    if (_capturedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture a photo'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Create student first
    final studentResult = await ApiService.createStudent({
      'student_id': _idController.text,
      'name': _nameController.text,
      'class_id': _selectedClass,
    });
    
    if (studentResult['success']) {
      // Register face
      final faceResult = await ApiService.registerFace(
        studentResult['data']['id'],
        _capturedImage!,
      );
      
      setState(() => _isLoading = false);
      
      if (faceResult['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student registered successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(faceResult['error']), backgroundColor: Colors.red),
        );
      }
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(studentResult['error']), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    CameraService.dispose();
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
                    height: 480,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _capturedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(_capturedImage!, fit: BoxFit.cover),
                          )
                        : _isCameraInitialized && CameraService.controller != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CameraPreview(CameraService.controller!),
                              )
                            : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt, size: 64, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text('Camera not available'),
                                  ],
                                ),
                              ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Capture/Retake Button
                  OutlinedButton.icon(
                    onPressed: _takePicture,
                    icon: Icon(Icons.camera_alt, color: theme.colorScheme.primary),
                    label: Text(_capturedImage == null ? "Capture Photo" : "Retake Photo", 
                               style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.bold)),
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
                  
                  ValidatedTextField(
                    label: "Student ID",
                    hint: "e.g. 2024001",
                    icon: Icons.badge,
                    controller: _idController,
                    validator: ValidationService.validateStudentId,
                  ),
                  const SizedBox(height: 16),
                  ValidatedTextField(
                    label: "Full Name",
                    hint: "Enter full name",
                    icon: Icons.person,
                    controller: _nameController,
                    validator: ValidationService.validateName,
                  ),
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
                          fillColor: isDark ? const Color(0xFF1A2633) : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Submit Button
                  LoadingButton(
                    text: "Register Student",
                    onPressed: _registerStudent,
                    isLoading: _isLoading,
                    icon: Icons.person_add,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTextField(BuildContext context, String label, String hint, IconData icon, TextEditingController controller) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: isDark ? const Color(0xFF1A2633) : Colors.white,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCorner(Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: color, width: 3),
          left: BorderSide(color: color, width: 3),
        ),
      ),
    );
  }
}