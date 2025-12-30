# 🚀 Deploying Face Recognition Attendance System to Render

This guide walks you through deploying your backend to [Render](https://render.com) for **free**.

## 📋 Prerequisites

1. A **GitHub account** (to host your code)
2. A **Render account** (sign up at [render.com](https://render.com) - free)
3. Your backend code pushed to a GitHub repository

---

## 🔧 Step 1: Prepare Your Repository

### 1.1 Create a new GitHub repository

1. Go to [github.com/new](https://github.com/new)
2. Name it something like `face-attendance-backend`
3. Set it to **Private** (recommended for security)
4. Click **Create repository**

### 1.2 Push your backend code

Open a terminal in the `attendance_backend` folder and run:

```bash
# Initialize git if not already done
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit - Face Attendance Backend"

# Add your GitHub repository as remote (replace with your URL)
git remote add origin https://github.com/YOUR_USERNAME/face-attendance-backend.git

# Push to GitHub
git branch -M main
git push -u origin main
```

---

## 🌐 Step 2: Deploy to Render

### Option A: One-Click Deploy with render.yaml (Recommended)

1. Go to [render.com](https://render.com) and sign in
2. Click **New** → **Blueprint**
3. Connect your GitHub account if not already connected
4. Select your `face-attendance-backend` repository
5. Render will automatically detect the `render.yaml` file
6. Click **Apply** to deploy

### Option B: Manual Setup

If you prefer manual setup:

#### 2.1 Create PostgreSQL Database

1. Go to Render Dashboard → **New** → **PostgreSQL**
2. Configure:
   - **Name**: `attendance-db`
   - **Database**: `attendance_db`
   - **User**: `attendance_user`
   - **Region**: Choose closest to your users
   - **Plan**: Free
3. Click **Create Database**
4. Copy the **Internal Database URL** for later

#### 2.2 Create Web Service

1. Go to Render Dashboard → **New** → **Web Service**
2. Connect your GitHub repository
3. Configure:
   - **Name**: `face-attendance-backend`
   - **Runtime**: Python 3
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
4. Add Environment Variables:
   | Key | Value |
   |-----|-------|
   | `DATABASE_URL` | (paste Internal Database URL from step 2.1) |
   | `SECRET_KEY` | (click Generate) |
   | `ALGORITHM` | `HS256` |
   | `ACCESS_TOKEN_EXPIRE_MINUTES` | `1440` |
   | `FACE_SIMILARITY_THRESHOLD` | `0.6` |
   | `INSIGHTFACE_MODEL_NAME` | `buffalo_l` |
   | `APP_NAME` | `Face Recognition Attendance System` |
   | `DEBUG` | `false` |

5. Add Persistent Disk (for file uploads):
   - **Name**: `uploads`
   - **Mount Path**: `/opt/render/project/src/uploads`
   - **Size**: 1 GB

6. Click **Create Web Service**

---

## ⏳ Step 3: Wait for Deployment

The first deployment takes **5-15 minutes** because:
- Installing InsightFace and OpenCV takes time
- The ML model needs to download on first start

You can monitor progress in the **Logs** tab.

---

## ✅ Step 4: Initialize the Database

After the first deployment succeeds:

1. Go to your Web Service on Render
2. Click **Shell** tab (or use the Console)
3. Run:
   ```bash
   python init_production_db.py
   ```

This creates the database tables and default admin user.

---

## 🔗 Step 5: Update Your Flutter App

After deployment, your backend URL will be:
```
https://face-attendance-backend.onrender.com
```

Update your Flutter app's API base URL:

```dart
// In your Flutter app's api_service.dart or similar
static const String baseUrl = 'https://face-attendance-backend.onrender.com';
```

---

## 🛡️ Step 6: Post-Deployment Security

1. **Change the default admin password** immediately:
   - Login with `admin@school.com` / `admin123`
   - Change the password via your app's user management

2. **Update CORS settings** (if needed):
   - Edit `app/main.py`
   - Replace `allow_origins=["*"]` with your specific domains

---

## ⚠️ Important Notes

### Free Tier Limitations

| Feature | Limit |
|---------|-------|
| **Compute Hours** | 750 hours/month |
| **RAM** | 512 MB |
| **Sleep** | After 15 min inactivity |
| **Cold Start** | 30-60 seconds to wake |

### Tips for Free Tier

1. **Cold Starts**: The first request after inactivity takes 30-60 seconds. Consider:
   - Using a cron job to ping `/health` every 10 minutes
   - Adding a loading indicator in your Flutter app

2. **Model Loading**: InsightFace model loads on startup (~30 seconds). This is included in cold start time.

3. **Database**: Free PostgreSQL has 1GB storage limit, sufficient for most schools.

---

## 🐛 Troubleshooting

### Build Fails

1. Check the **Logs** in Render dashboard
2. Common issues:
   - Missing dependencies in `requirements.txt`
   - Python version mismatch (we use 3.11)

### Database Connection Errors

1. Verify `DATABASE_URL` environment variable is set
2. Ensure database is in the same region as your web service

### Face Recognition Not Working

1. Check if InsightFace model loaded (check logs for "InsightFace model loaded")
2. Verify `INSIGHTFACE_MODEL_NAME` environment variable

### Uploads Not Persisting

1. Verify disk is mounted at `/opt/render/project/src/uploads`
2. Check disk size hasn't exceeded 1GB

---

## 📧 Support

If you encounter issues:
1. Check Render's [documentation](https://render.com/docs)
2. Review the deployment logs
3. Ensure all environment variables are set correctly

---

## 🎉 You're Done!

Your Face Recognition Attendance System is now live on the internet!

**Your API endpoints:**
- API Docs: `https://face-attendance-backend.onrender.com/docs`
- Health Check: `https://face-attendance-backend.onrender.com/health`
