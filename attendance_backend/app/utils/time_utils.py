"""Time and date utilities"""
from datetime import datetime, timezone
import pytz

def get_current_timestamp():
    """Get current UTC timestamp"""
    return datetime.now(timezone.utc)

def format_timestamp(timestamp):
    """Format timestamp for display"""
    return timestamp.strftime("%Y-%m-%d %H:%M:%S")

def is_within_attendance_window(current_time, start_time="08:00", end_time="10:00"):
    """Check if current time is within attendance window"""
    current_hour_min = current_time.strftime("%H:%M")
    return start_time <= current_hour_min <= end_time