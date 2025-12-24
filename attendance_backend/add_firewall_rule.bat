@echo off
echo ============================================
echo Face Attendance Backend - Firewall Setup
echo ============================================
echo.
echo Adding firewall rule for port 8000...
echo.

netsh advfirewall firewall add rule name="Face Attendance Backend" dir=in action=allow protocol=TCP localport=8000

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Firewall rule added successfully!
    echo.
    echo Your backend server can now accept connections from your phone.
    echo.
) else (
    echo.
    echo [ERROR] Failed to add firewall rule.
    echo Please run this script as Administrator.
    echo.
    echo Right-click this file and select "Run as administrator"
    echo.
)

echo.
echo Press any key to exit...
pause >nul
