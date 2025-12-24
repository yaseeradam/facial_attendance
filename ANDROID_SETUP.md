# Quick Setup Guide - Android Phone Login

## ✅ What I've Done

1. **Updated API Configuration**: Changed from emulator IP to your computer's IP
   - File: `lib/services/api_service.dart`
   - New URL: `http://192.168.43.70:8000`

2. **Verified Server**: Backend is running and port 8000 is accessible

## 🔧 What You Need To Do

### Step 1: Run Firewall Script (AS ADMINISTRATOR)
1. Navigate to: `attendance_backend` folder
2. Right-click `add_firewall_rule.bat`
3. Select **"Run as administrator"**
4. Click **Yes**

### Step 2: Rebuild Flutter App
```bash
flutter clean
flutter pub get
flutter run
```

### Step 3: Test on Phone
**Login Credentials:**
- Email: `admin@school.com`
- Password: `admin123`

## 🧪 Quick Test

Before trying the app, test if your phone can reach the server:

**On your phone's browser, open:**
```
http://192.168.43.70:8000/docs
```

✅ If you see API docs → Server is reachable  
❌ If error → Check WiFi connection

## ⚠️ Important

- Computer and phone MUST be on the same WiFi
- Backend server must be running
- If your computer's IP changes, update `api_service.dart`

## 📞 Tell Me

1. Did the firewall script run successfully?
2. Can you see the API docs in your phone's browser?
3. What error (if any) do you get when logging in?
