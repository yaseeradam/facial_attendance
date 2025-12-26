# Register Student Screen - Auto-Capture Update

## Changes Made (2025-12-25)

### 🎯 New Layout Structure

```
┌──────────────────────┐
│  Top Navigation      │  
├──────────────────────┤
│                      │
│  Camera (Top 60%)    │
│  • Live feedback     │
│  • ML Kit guidance   │
│  • Face frame        │
│                      │
├──────────────────────┤
│ Form Sheet (40%)     │
│ ┌──────────────────┐ │
│ │ Handle           │ │
│ │ Student ID       │ │
│ │ Full Name        │ │
│ │ Class Selector   │ │
│ └──────────────────┘ │
└──────────────────────┘
```

### ✨ Features Added

#### 1. **Persistent Bottom Sheet with Form**
- Always visible at bottom (40% of screen)
- Contains registration form:
  - Student ID input
  - Full Name input
  - Class dropdown selector
- No shimmer - just the actual form inputs
- Scrollable when keyboard appears

#### 2. **Auto-Capture Face Registration**
- Uses ML Kit face detection (same as Mark Attendance)
- Real-time guidance messages:
  - "No face detected"
  - "Please open your eyes"
  - "Please look straight"
  - "Hold steady... 5" (countdown)
  - "Capturing..." (when auto-capturing)
  
#### 3. **Camera at Top**
- Takes 60% of screen height
- Shows live camera feed
- Dynamic face frame that changes color:
  - White (faint): No face detected
  - Orange: Face detected but not properly positioned
  - Green: Ready to capture
- Scanning line animation

#### 4. **Automatic Registration Flow**

**User Experience:**
1. User fills in Student ID, Name, and selects Class
2. User positions face in the frame
3. ML Kit checks:
   - Head position (must be straight)
   - Eyes (must be open)
   - Liveness (eyes open = live person)
4. When face is valid for **5 consecutive frames**:
   - **Automatically captures** photo
   - **Automatically calls** registration API
   - Shows "Registering student..." message
5. On success:
   - Shows success message
   - Closes screen, returns to previous page
6. On error:
   - Shows error message
   - User can wait 5 seconds and try again

### 🔒 Safety Features

1. **Form Validation Required**
   - Auto-capture only triggers if form is valid
   - All fields must be filled

2. **Cooldown Period**
   - 5-second cooldown between captures
   - Prevents multiple rapid captures

3. **Consecutive Frame Check**
   - Requires 5 frames where face is valid
   - Prevents accidental captures from quick movements

4. **Data Only Saved on Success**
   - If API call fails, nothing is saved
   - Database remains clean

### 📱 No Manual Button Needed
- ❌ Removed "Scan & Register Student" button
- ✅ Automatic capture when face is ready
- ✅ User just needs to position face correctly

### 🎨 Visual Feedback

**Face Frame Colors:**
- ⚪ White: No face / Not ready
- 🟠 Orange: Face detected but needs adjustment
- 🟢 Green: Perfect! Auto-capturing soon

**Guidance Messages:**
- Real-time instructions
- Countdown when almost ready
- "Capturing..." during registration

### 🔄 User Flow Comparison

**Before:**
1. Fill form
2. Position face
3. **Click button**
4. Wait for result

**After:**
1. Fill form
2. Position face
3. **Wait 1 second** (auto-capture!)
4. Automatic registration

## Testing Instructions

1. **Open Register Student screen**
2. **Fill the form**:
   - Enter Student ID
   - Enter Full Name
   - Select a Class
3. **Position face in frame**
4. **Watch the guidance**:
   - "No face detected" → Move closer
   - "Please look straight" → Adjust head position
   - "Please open your eyes" → Open eyes
   - "Hold steady... 5, 4, 3, 2, 1" → Stay still!
   - "Capturing..." → Photo taken automatically!
5. **Watch registration**:
   - Shows "Registering student..."
   - Success → Returns to previous screen
   - Error → Shows error message

## Files Modified
- `lib/screens/register_student_screen.dart` - Complete redesign with auto-capture

## Benefits
✅ Faster workflow - no button press needed
✅ Better UX - automatic when ready
✅ Same familiar layout as Mark Attendance
✅ Real-time guidance for users
✅ Prevents errors with ML Kit validation
