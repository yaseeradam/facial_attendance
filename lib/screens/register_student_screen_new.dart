import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../services/api_service.dart';
import '../utils/ui_helpers.dart';

class RegisterStudentScreenNew extends StatefulWidget {
  const RegisterStudentScreenNew({super.key});

  @override
  State<RegisterStudentScreenNew> createState() => _RegisterStudentScreenNewState();
}

class _RegisterStudentScreenNewState extends State<RegisterStudentScreenNew> 
    with TickerProviderStateMixin {
  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _nameController = TextEditingController();
  
  // Camera & Face Detection
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  CameraLensDirection _cameraDirection = CameraLensDirection.front; // Start with front camera
  FaceDetector? _faceDetector;
  bool _isDetectingFaces = false;
  bool _isProcessingImage = false;
  
  // Animation Controllers
  late AnimationController _scanAnimationController;
  late AnimationController _successPulseController;
  late Animation<double> _successPulseAnimation;
  
  // Face Scanning State
  List<XFile> _capturedFaces = []; // Store 3 face scans
  int _currentScanCount = 0;
  final int _requiredScans = 3;
  bool _isScanningPhase = true; // true = scanning, false = form filling
  bool _isCapturing = false;
  
  // Face Detection Feedback
  String _faceGuidanceMessage = "Position your face in the frame";
  Color _faceGuidanceColor = Colors.white70;
  bool _isFaceValid = false;
  bool _isLivenessVerified = false;
  bool _faceDetected = false;
  int _readyFrameCount = 0;
  static const _requiredReadyFrames = 10; // More frames for better quality
  
  // Form State
  int? _selectedClassId;
  List<Map<String, dynamic>> _classes = [];
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _loadClasses();
    _initializeFaceDetector();
    _initializeCamera();
    
    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    _successPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _successPulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _successPulseController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  void _initializeFaceDetector() {
    final options = FaceDetectorOptions(
      enableClassification: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.accurate, // More accurate for registration
      minFaceSize: 0.2, // Larger face required
    );
    _faceDetector = FaceDetector(options: options);
  }

  Future<void> _loadClasses() async {
    final result = await ApiService.getClasses();
    if (!mounted) return;
    
    if (result['success']) {
      setState(() {
        _classes = List<Map<String, dynamic>>.from(result['data'] ?? []);
      });
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      
      final selectedCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == _cameraDirection,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium, // Medium for better performance
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21, // NV21 required for image stream on Android
      );

      await _cameraController!.initialize();
      
      if (mounted) {
        setState(() => _isCameraInitialized = true);
        _startFaceDetection();
      }
    } catch (e) {
      debugPrint('Camera Error: $e');
    }
  }
  
  Future<void> _flipCamera() async {
    if (_isCapturing) return; // Don't flip while capturing
    
    // Stop detection and dispose current camera
    _stopFaceDetection();
    await _cameraController?.dispose();
    
    // Toggle camera direction
    setState(() {
      _cameraDirection = _cameraDirection == CameraLensDirection.front
          ? CameraLensDirection.back
          : CameraLensDirection.front;
      _isCameraInitialized = false;
    });
    
    // Reinitialize with new direction
    await _initializeCamera();
  }
  
  void _startFaceDetection() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    
    _isDetectingFaces = true;
    _cameraController!.startImageStream((CameraImage image) {
      if (!_isDetectingFaces || _isProcessingImage || _isCapturing || !_isScanningPhase) return;
      _processImageForFaceDetection(image);
    });
  }
  
  void _stopFaceDetection() {
    _isDetectingFaces = false;
    if (_cameraController != null && _cameraController!.value.isStreamingImages) {
      _cameraController!.stopImageStream();
    }
  }
  
  Future<void> _processImageForFaceDetection(CameraImage image) async {
    if (_faceDetector == null || _isProcessingImage) return;
    
    _isProcessingImage = true;
    
    try {
      final inputImage = _convertCameraImageToInputImage(image);
      if (inputImage == null) {
        _isProcessingImage = false;
        return;
      }
      
      final faces = await _faceDetector!.processImage(inputImage);
      
      if (!mounted) {
        _isProcessingImage = false;
        return;
      }
      
      _updateFaceGuidance(faces);
    } catch (e) {
      debugPrint('Face detection error: $e');
    }
    
    _isProcessingImage = false;
  }
  
  InputImage? _convertCameraImageToInputImage(CameraImage image) {
    try {
      final camera = _cameraController!.description;
      final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
      
      if (rotation == null) return null;
      
      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) return null;
      
      final plane = image.planes.first;
      
      return InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: plane.bytesPerRow,
        ),
      );
    } catch (e) {
      debugPrint('Image conversion error: $e');
      return null;
    }
  }
  
  void _updateFaceGuidance(List<Face> faces) {
    if (!mounted) return;
    
    setState(() {
      if (faces.isEmpty) {
        _faceDetected = false;
        _isFaceValid = false;
        _isLivenessVerified = false;
        _faceGuidanceMessage = "No face detected";
        _faceGuidanceColor = Colors.orange;
        _readyFrameCount = 0;
        return;
      }
      
      final face = faces.first;
      _faceDetected = true;
      
      final headAngleY = face.headEulerAngleY;
      final headAngleZ = face.headEulerAngleZ;
      final leftEyeOpen = face.leftEyeOpenProbability;
      final rightEyeOpen = face.rightEyeOpenProbability;
      
      bool isHeadStraight = headAngleY != null && headAngleZ != null &&
                           headAngleY.abs() <= 12 && headAngleZ.abs() <= 8;
      bool eyesOpen = leftEyeOpen != null && rightEyeOpen != null &&
                     leftEyeOpen > 0.5 && rightEyeOpen > 0.5;
      
      _isFaceValid = isHeadStraight && eyesOpen;
      _isLivenessVerified = eyesOpen;
      
      if (!eyesOpen) {
        _faceGuidanceMessage = "Please open your eyes";
        _faceGuidanceColor = Colors.orange;
        _readyFrameCount = 0;
      } else if (!isHeadStraight) {
        _faceGuidanceMessage = "Please look straight";
        _faceGuidanceColor = Colors.orange;
        _readyFrameCount = 0;
      } else if (_isFaceValid && _isLivenessVerified) {
        _readyFrameCount++;
        
        if (_readyFrameCount >= _requiredReadyFrames && !_isCapturing) {
          _faceGuidanceMessage = "Perfect! Capturing...";
          _faceGuidanceColor = Colors.green;
          Future.microtask(() => _captureFace());
        } else {
          _faceGuidanceMessage = "Hold steady... ${_requiredReadyFrames - _readyFrameCount}";
          _faceGuidanceColor = Colors.green;
        }
      } else {
        _faceGuidanceMessage = "Hold steady...";
        _faceGuidanceColor = Colors.white70;
        _readyFrameCount = 0;
      }
    });
  }
  
  Future<void> _captureFace() async {
    if (_isCapturing || _currentScanCount >= _requiredScans) return;
    
    setState(() => _isCapturing = true);
    
    try {
      // Stop face detection temporarily
      _stopFaceDetection();
      
      // Wait a moment for image stream to stop
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Capture the photo
      final XFile photo = await _cameraController!.takePicture();
      
      if (mounted) {
        setState(() {
          _capturedFaces.add(photo);
          _currentScanCount++;
          _readyFrameCount = 0;
        });
        
        // Play success animation
        _successPulseController.forward().then((_) {
          _successPulseController.reverse();
        });
        
        // If we've captured all 3 scans, move to form phase
        if (_currentScanCount >= _requiredScans) {
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            setState(() => _isScanningPhase = false);
            // Dispose camera since we're done scanning
            _cameraController?.dispose();
            _cameraController = null;
          }
        } else {
          // Wait 2 seconds before next scan
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            setState(() => _isCapturing = false);
            // Restart face detection for next scan
            _startFaceDetection();
          }
        }
      }
    } catch (e) {
      debugPrint('Error capturing face: $e');
      if (mounted) {
        setState(() => _isCapturing = false);
        _startFaceDetection();
      }
    }
  }
  
  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate() || _selectedClassId == null) {
      UIHelpers.showWarning(context, "Please fill all fields and select a class");
      return;
    }
    
    if (_capturedFaces.length < _requiredScans) {
      UIHelpers.showWarning(context, "Please complete face scanning first");
      return;
    }

    if (!mounted) return;
    setState(() => _isRegistering = true);

    try {
      // 1. Check if face is already registered
      final verifyResult = await ApiService.verifyFace(
        imageFile: File(_capturedFaces[0].path),
      );

      if (verifyResult['success'] == true && verifyResult['data']['success'] == true) {
        if (!mounted) return;
        final studentName = verifyResult['data']['student_name'];
        final studentId = verifyResult['data']['student_id'];
        
        // Show specific error for duplicate face
        UIHelpers.showError(
          context, 
          "This person is already registered as:\n$studentName (ID: $studentId)",
        );
        setState(() => _isRegistering = false);
        return;
      }

      // 2. Proceed with registration if face is not found
      final result = await ApiService.registerStudent(
        studentId: _studentIdController.text,
        name: _nameController.text,
        classId: _selectedClassId!,
        imageFile: File(_capturedFaces[0].path), // Using first scan
      );

      if (!mounted) return;
      
      if (result['success']) {
        UIHelpers.showSuccess(context, "Student Registered Successfully! Face embeddings saved.");
        if (mounted) Navigator.pop(context, true);
      } else {
        final errorMsg = result['error']?.toString() ?? 'Unknown error';
        UIHelpers.showError(context, "Registration Failed: $errorMsg");
      }
    } catch (e) {
      if (mounted) {
        UIHelpers.showError(context, "Error: $e");
      }
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }
  
  void _retakeScan(int index) {
    setState(() {
      _capturedFaces.removeAt(index);
      _currentScanCount--;
      _isScanningPhase = true;
    });
    
    // Reinitialize camera
    _initializeCamera();
  }
  
  void _resetAllScans() {
    setState(() {
      _capturedFaces.clear();
      _currentScanCount = 0;
      _isScanningPhase = true;
    });
    
    // Reinitialize camera
    _initializeCamera();
  }

  @override
  void dispose() {
    _stopFaceDetection();
    _cameraController?.dispose();
    _faceDetector?.close();
    _scanAnimationController.dispose();
    _successPulseController.dispose();
    _studentIdController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E2936) : Colors.white,
        elevation: 0,
        title: Text(
          _isScanningPhase ? "Scan Face" : "Register Student",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _isScanningPhase ? _buildScanningPhase(theme, isDark) : _buildFormPhase(theme, isDark),
      ),
    );
  }
  
  Widget _buildScanningPhase(ThemeData theme, bool isDark) {
    return Column(
      children: [
        // Progress Indicator
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Scan $_currentScanCount/$_requiredScans",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Please position your face in the frame",
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              // Progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_requiredScans, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 40,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index < _currentScanCount 
                          ? Colors.green 
                          : (index == _currentScanCount && _isFaceValid
                              ? Colors.orange
                              : Colors.grey[300]),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        
        // Camera Viewport
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Camera Feed
                  if (_isCameraInitialized && _cameraController != null)
                    CameraPreview(_cameraController!)
                  else
                    Container(
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        stops: const [0.0, 0.3, 1.0],
                      ),
                    ),
                  ),
                  
                  // Scanning UI Overlay
                  _buildScanningOverlay(theme),
                  
                  // Flip Camera Button (top-right)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _flipCamera,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.flip_camera_android,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Captured Previews
        if (_capturedFaces.isNotEmpty)
          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _capturedFaces.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          File(_capturedFaces[index].path),
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        
        const SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildScanningOverlay(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use 70% of available width, max 280
        final faceFrameSize = (constraints.maxWidth * 0.7).clamp(200.0, 280.0);
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Guidance Message
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                border: Border.all(
                  color: _faceGuidanceColor.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _faceDetected 
                        ? (_isFaceValid && _isLivenessVerified 
                            ? Icons.check_circle 
                            : Icons.info_outline)
                        : Icons.face_retouching_off,
                    color: _faceGuidanceColor,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      _faceGuidanceMessage,
                      style: TextStyle(
                        color: _faceGuidanceColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            
            // Face Frame (dynamic size)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: faceFrameSize,
              height: faceFrameSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isFaceValid && _isLivenessVerified
                      ? Colors.green.withOpacity(0.8)
                      : _faceDetected
                          ? Colors.orange.withOpacity(0.6)
                          : Colors.white.withOpacity(0.2),
                  width: _isFaceValid && _isLivenessVerified ? 2.5 : 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // Scanning Line
                  if (!_isCapturing)
                    AnimatedBuilder(
                      animation: _scanAnimationController,
                      builder: (context, child) {
                        return Positioned(
                          top: faceFrameSize * _scanAnimationController.value,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: (_isFaceValid && _isLivenessVerified)
                                  ? Colors.green.withOpacity(0.8)
                                  : theme.colorScheme.primary.withOpacity(0.8),
                              boxShadow: [
                                BoxShadow(
                                  color: (_isFaceValid && _isLivenessVerified)
                                      ? Colors.green.withOpacity(0.8)
                                      : theme.colorScheme.primary.withOpacity(0.8),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              _isCapturing 
                  ? "Capturing scan $_currentScanCount..."
                  : (_isFaceValid && _isLivenessVerified
                      ? "Perfect position!"
                      : "Position your face in the frame"),
              style: TextStyle(
                color: _isFaceValid && _isLivenessVerified
                    ? Colors.green[300]
                    : Colors.white70,
                fontSize: 13,
                fontWeight: _isFaceValid && _isLivenessVerified
                    ? FontWeight.w600
                    : FontWeight.w300,
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildFormPhase(ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Success Message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Face Scans Completed!",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "$_requiredScans scans captured successfully",
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _resetAllScans,
                    child: const Text("Retake"),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Captured Face Previews
            const Text(
              "Captured Face Scans",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _capturedFaces.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            File(_capturedFaces[index].path),
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Form Title
            const Text(
              "Student Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Student ID Field
            TextFormField(
              controller: _studentIdController,
              decoration: InputDecoration(
                labelText: "Student ID",
                prefixIcon: const Icon(Icons.badge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E2936) : Colors.white,
              ),
              validator: (v) => v!.isEmpty ? "Student ID is required" : null,
            ),
            
            const SizedBox(height: 16),
            
            // Full Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E2936) : Colors.white,
              ),
              validator: (v) => v!.isEmpty ? "Full Name is required" : null,
            ),
            
            const SizedBox(height: 16),
            
            // Class Selection
            DropdownButtonFormField<int>(
              value: _selectedClassId,
              decoration: InputDecoration(
                labelText: "Class",
                prefixIcon: const Icon(Icons.class_),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E2936) : Colors.white,
              ),
              items: _classes.map((c) => DropdownMenuItem<int>(
                value: c['id'],
                child: Text(c['class_name'] ?? c['name']),
              )).toList(),
              onChanged: (v) => setState(() => _selectedClassId = v),
              validator: (v) => v == null ? "Please select a class" : null,
            ),
            
            const SizedBox(height: 32),
            
            // Register Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isRegistering ? null : _handleRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: _isRegistering
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Register Student",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Info Text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Face will be converted to embeddings and saved securely for attendance verification",
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
