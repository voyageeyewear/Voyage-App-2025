# Deploy Backend to Railway (Free Cloud Hosting)

## 🚀 Make Your App Work on ANY Network!

Currently, your app only works on the same WiFi network because you're using:
```
http://192.168.31.183:3000  ❌ (Only works on local network)
```

After deployment, your app will use:
```
https://your-app.railway.app  ✅ (Works everywhere!)
```

---

## 📋 Steps to Deploy Backend to Railway

### **Step 1: Create Railway Account**

1. Go to: https://railway.app
2. Click "Sign Up"
3. Sign in with GitHub (or email)
4. It's FREE! (No credit card needed)

---

### **Step 2: Install Railway CLI**

```bash
# Install Railway CLI
npm install -g @railway/cli

# Or using curl
curl -fsSL https://railway.app/install.sh | sh
```

---

### **Step 3: Login to Railway**

```bash
# Login to Railway
railway login
```

This will open your browser. Click "Authorize" to connect.

---

### **Step 4: Prepare Your Backend**

```bash
cd /Users/dhruv/Desktop/Voyage-app-2025/voyage_backend
```

Create a `Procfile` (tells Railway how to start your app):

```bash
echo "web: node server.js" > Procfile
```

---

### **Step 5: Deploy to Railway**

```bash
# Initialize Railway project
railway init

# Give it a name: "voyage-backend"

# Deploy your backend
railway up

# Set environment variables
railway variables set SHOPIFY_STORE_DOMAIN=voyage-eyewear.myshopify.com
railway variables set SHOPIFY_API_KEY=your-api-key
railway variables set SHOPIFY_ADMIN_ACCESS_TOKEN=your-access-token
railway variables set SHOPIFY_API_VERSION=2024-07

# Get your public URL
railway domain
```

---

### **Step 6: Copy Your Public URL**

Railway will give you a URL like:
```
https://voyage-backend-production.up.railway.app
```

**Copy this URL!** ✅

---

### **Step 7: Update Flutter App**

Open: `voyage_flutter_app/lib/utils/constants.dart`

Change:
```dart
static const String apiBaseUrl = 'http://192.168.31.183:3000';  ❌
```

To:
```dart
static const String apiBaseUrl = 'https://voyage-backend-production.up.railway.app';  ✅
```

---

### **Step 8: Rebuild APK**

```bash
cd /Users/dhruv/Desktop/Voyage-app-2025
bash UPDATE_APK.sh
```

---

## ✅ Done! Your App Now Works Everywhere!

- ✅ Works on mobile data (4G/5G)
- ✅ Works on any WiFi network
- ✅ Works anywhere in the world
- ✅ Always online (Railway keeps it running)

---

## 🔄 Alternative: Quick Testing with Ngrok

If you just want to test quickly:

```bash
# Install ngrok
npm install -g ngrok

# Start your backend
cd /Users/dhruv/Desktop/Voyage-app-2025/voyage_backend
npm start

# In another terminal, expose it
ngrok http 3000
```

Ngrok will give you a URL like:
```
https://abc123.ngrok.io
```

Use this in your Flutter app temporarily.

**Note:** Ngrok URLs change every restart. Railway is permanent!

---

## 🎯 Best Solution: Railway

✅ **Free forever** (500 hours/month)
✅ **Permanent URL** (doesn't change)
✅ **Automatic restarts** (if server crashes)
✅ **HTTPS included** (secure)
✅ **Easy to update** (just `railway up`)

---

## 🆘 Need Help?

If Railway deployment fails, you can also try:
- **Render.com** (similar to Railway, also free)
- **Heroku** (needs credit card for free tier)
- **Vercel** (for Node.js apps)

Let me know which option you prefer!

