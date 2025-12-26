# New Face Attendance Screens - Integration Guide

## Overview
Two new screens have been created to enhance the face attendance workflow:

1. **RegisterStudentScreenNew** - 3-scan face registration with form
2. **ScanAttendanceScreen** - Face recognition with detailed student information

---

## 1. Register Student Screen (register_student_screen_new.dart)

### Features:
- **3-Scan Workflow**: Automatically captures face 3 times for better accuracy
- **Two-Phase Process**:
  - **Phase 1**: Face Scanning (camera at top, auto-captures when face is properly positioned)
  - **Phase 2**: Form Filling (manual entry of student details with face previews)
- **Real-time Feedback**: Shows guidance messages for proper face positioning
- **Face Embeddings**: Automatically converts captured face to embeddings and saves to backend

### How It Works:
1. User opens registration screen
2. Camera activates and shows real-time face detection
3. When face is properly positioned (straight, eyes open), automatically captures 3 scans with 2-second intervals
4. After 3 scans, camera closes and form appears
5. User fills in Student ID, Name, and selects Class
6. On submit, the face is sent to backend which:
   - Saves the image as profile picture
   - Converts face to embeddings using InsightFace
   - Stores embeddings in database for future recognition

### Usage in App:
```dart
// Navigate to new register screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const RegisterStudentScreenNew(),
  ),
);
```

---

## 2. Scan Attendance Screen (scan_attendance_screen.dart)

### Features:
- **Auto Face Recognition**: Uses stored embeddings to identify students
- **Detailed Student Card**: Shows comprehensive information when recognized
- **Real-time Feedback**: Visual guidance for face positioning
- **Attendance Marking**: Automatically marks attendance when face is recognized
- **Beautiful UI**: Animated card slide-in with student details

### Student Details Shown:
- Student Name
- Student ID
- Confidence Score (how well the face matched)
- Attendance Status (marked or already marked)
- Current Time

### How It Works:
1. Teacher selects a class from dropdown
2. Camera activates with real-time face detection
3. When face is properly positioned, auto-captures
4. Backend performs face matching using embeddings:
   - Generates embedding from captured face
   - Compares with all student embeddings in selected class
   - Returns best match if similarity > threshold
5. If recognized:
   - Shows student details in animated card
   - Marks attendance automatically
   - Displays confidence score
6. If not recognized:
   - Shows error state
   - Teacher can try again

### Usage in App:
```dart
// Navigate to scan attendance screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ScanAttendanceScreen(),
  ),
);
```

---

## Backend Integration

Both screens use existing backend endpoints:

### Registration Endpoint:
```
POST /face/register
- student_id: int
- file: image file
```
Backend automatically:
- Validates student exists
- Processes image and extracts face
- Generates 512-dimension embedding using InsightFace
- Saves embedding as JSON in database
- Updates student.face_enrolled = true

### Verification/Attendance Endpoint:
```
POST /face/verify
- class_id: int
- file: image file
```
Backend automatically:
- Generates embedding from input image
- Retrieves all embeddings for students in class
- Finds best match using cosine similarity
- Marks attendance if match found
- Returns student details and confidence score

---

## Face Embedding Technology

### What are Embeddings?
Face embeddings are 512-dimensional numerical vectors that represent unique facial features. Each student's face is converted to this vector during registration.

### How Recognition Works:
1. **Registration**: Face → InsightFace Model → 512D Vector → Database
2. **Verification**: New Face → 512D Vector → Compare with all vectors → Find best match
3. **Matching**: Uses cosine similarity to measure how close two vectors are (0-1 scale)
4. **Threshold**: Match accepted if similarity > 0.5 (configurable)

### Benefits:
- **Fast**: Comparing vectors is much faster than comparing images
- **Accurate**: InsightFace model is highly accurate for face recognition
- **Privacy**: Original images can be deleted, only embeddings are needed
- **Small**: 512 numbers take very little storage vs full images

---

## Replacing Old Screens

### Option 1: Direct Replacement
Simply replace the imports in your navigation/routing:

```dart
// OLD
import 'package:frontalminds_fr/screens/register_student_screen.dart';
import 'package:frontalminds_fr/screens/mark_attendance_screen_1.dart';

// NEW
import 'package:frontalminds_fr/screens/register_student_screen_new.dart';
import 'package:frontalminds_fr/screens/scan_attendance_screen.dart';
```

### Option 2: Test Side-by-Side
Keep both versions and create a settings toggle to switch between them.

### Option 3: Gradual Migration
Use new screens for new features, keep old screens for existing workflows.

---

## Customization Options

### Adjust Face Scanning Parameters:

**Register Screen** (register_student_screen_new.dart):
```dart
final int _requiredScans = 3;  // Change number of scans
static const _requiredReadyFrames = 10;  // Frames before capture
```

**Scan Screen** (scan_attendance_screen.dart):
```dart
static const _requiredReadyFrames = 5;  // Frames before capture
static const _autoCaptureCooldown = Duration(seconds: 5);  // Wait between scans
```

### Adjust Face Detection Strictness:

```dart
// More strict (better quality)
bool isHeadStraight = headAngleY.abs() <= 10 && headAngleZ.abs() <= 5;

// Less strict (easier to capture)
bool isHeadStraight = headAngleY.abs() <= 20 && headAngleZ.abs() <= 15;
```

---

## UI Customization

Both screens use your app's theme automatically. Colors adapt to dark/light mode.

### To customize colors:
Edit the theme in your main app file or modify directly in the screens.

### Key UI Elements:
- **Face Frame**: Changes color based on detection (white → orange → green)
- **Guidance Messages**: Real-time feedback for user
- **Progress Indicators**: Visual cues for scanning progress
- **Student Card**: Animated slide-in with details

---

## Testing Checklist

### Registration Testing:
- [ ] Camera initializes properly
- [ ] Face detection works in real-time
- [ ] Auto-capture triggers when face is valid
- [ ] All 3 scans are captured
- [ ] Form appears after scanning
- [ ] Can fill and submit form
- [ ] Backend receives and saves embeddings
- [ ] Success message shows

### Attendance Testing:
- [ ] Class selection works
- [ ] Camera shows live preview
- [ ] Face detection provides feedback
- [ ] Auto-capture works
- [ ] Registered faces are recognized
- [ ] Student details display correctly
- [ ] Attendance is marked
- [ ] Unregistered faces show error
- [ ] Can scan multiple students

---

## Troubleshooting

### Camera not initializing:
- Check camera permissions in AndroidManifest.xml / Info.plist
- Ensure device has working camera
- Check if other apps can access camera

### Face not being detected:
- Ensure good lighting
- Face should be front-facing
- Adjust minFaceSize in FaceDetectorOptions
- Check if google_mlkit_face_detection is properly installed

### Recognition not working:
- Verify backend is running
- Check network connectivity
- Ensure student was properly registered with face
- Check backend logs for errors
- Verify embeddings were saved in database

### Low confidence scores:
- Ensure good lighting during both registration and scanning
- Make sure face is straight and clear
- Consider requiring higher quality images
- Adjust similarity threshold in backend

---

## Future Enhancements

Possible improvements:
1. **Multi-face capture**: Average embeddings from all 3 scans for better accuracy
2. **Live preview**: Show confidence score in real-time before capture
3. **Face quality check**: Reject blurry or low-quality images
4. **Batch attendance**: Scan multiple students in quick succession
5. **History view**: Show recently marked attendance
6. **Photo verification**: Show captured photo with student details
7. **Export reports**: Generate attendance reports from the app

---

## Support

For any issues or questions:
1. Check backend logs in: `attendance_backend/`
2. Check Flutter console for error messages
3. Verify database has student and embedding records
4. Test API endpoints using Postman or curl

Backend is running on: http://localhost:8000
API docs available at: http://localhost:8000/docs
