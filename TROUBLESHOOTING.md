# 🔧 Fix Timeout Exception - Network Connection Issue

## Problem
Your app shows: **"timeout exception after 0:0.0:30 future"**

This means the app can't connect to the backend server within 30 seconds.

---

## ✅ Backend Status
- **Backend Server:** ✅ Running on port 8000
- **Computer IP:** 192.168.43.70
- **App trying to connect to:** http://192.168.43.70:8000

---

## 🔍 Troubleshooting Steps

### Step 1: Verify Both Devices on Same WiFi

**On Your Computer:**
1. Check WiFi network name
2. Note: Your IP is `192.168.43.70`

**On Your Phone:**
1. Go to Settings → WiFi
2. Make sure you're connected to **THE SAME WiFi network** as your computer
3. If not, connect to the same network

### Step 2: Test Backend Connection

**On your phone's browser (Chrome/Firefox):**
1. Open: `http://192.168.43.70:8000/docs`
2. You should see FastAPI documentation page

**If it works:**
- ✅ Network is fine
- ❌ Issue is in the app (go to Step 4)

**If it doesn't work:**
- ❌ Network/firewall issue (go to Step 3)

### Step 3: Fix Firewall (If browser test failed)

The firewall rule should already exist, but let's verify:

**Run in PowerShell as Administrator:**
```powershell
netsh advfirewall firewall show rule name="Python Backend Port 8000"
```

**If rule doesn't exist, create it:**
```powershell
netsh advfirewall firewall add rule name="Python Backend Port 8000" dir=in action=allow protocol=TCP localport=8000
```

### Step 4: Reduce Timeout (If network is fine)

The app times out after 30 seconds. Let's increase it:

**File:** `lib/services/api_service.dart`

Find line 39 and change:
```dart
response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 30));
```

To:
```dart
response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 60));
```

Do the same for lines 47, 50, 54, 57, and 96.

---

## 🚀 Alternative Solution: Use Localhost (USB)

If WiFi doesn't work, use USB connection:

### Requirements:
- Phone connected via USB
- USB debugging enabled

### Steps:

1. **Enable USB Debugging on Phone:**
   - Settings → About Phone → Tap "Build Number" 7 times
   - Settings → Developer Options → Enable "USB Debugging"

2. **Connect Phone via USB**

3. **Setup Port Forwarding:**
   ```bash
   # Find adb.exe in your Android SDK
   # Usually: C:\Users\HP\AppData\Local\Android\Sdk\platform-tools\adb.exe
   
   adb reverse tcp:8000 tcp:8000
   ```

4. **Change API URL:**
   
   **File:** `lib/services/api_service.dart` line 12
   
   Change from:
   ```dart
   static const String baseUrl = 'http://192.168.43.70:8000';
   ```
   
   To:
   ```dart
   static const String baseUrl = 'http://localhost:8000';
   ```

5. **Rebuild App:**
   ```bash
   flutter clean
   flutter run
   ```

---

## 📱 Quick Test

After any fix, test the connection:

1. Open the app
2. Try to login with:
   - Email: `admin@school.com`
   - Password: `admin123`

**If login works:** ✅ Connection fixed!  
**If timeout again:** Try alternative solution above

---

## 🆘 Still Not Working?

Tell me:
1. Can you open `http://192.168.43.70:8000/docs` in your phone's browser?
2. Are both devices on the same WiFi network?
3. What error message do you see exactly?
