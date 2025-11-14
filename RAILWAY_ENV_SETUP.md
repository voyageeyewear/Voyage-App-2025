# 🚂 Railway Environment Variables Setup

## ✅ What I Just Fixed

1. ✅ Created `railway.json` - Tells Railway where your backend is
2. ✅ Created `nixpacks.toml` - Configures build process
3. ✅ Pushed to GitHub - Railway is now redeploying

---

## 🔧 What YOU Need to Do Now

Railway needs your Shopify credentials. Follow these steps:

### Step 1: Go to Railway Dashboard

You should still have the Railway tab open showing:
```
Voyage-App-2025
FAILED (15 seconds ago)
```

### Step 2: Click on "Variables" Tab

At the top, you'll see tabs:
- Deployments
- **Variables** ← Click this
- Metrics  
- Settings

### Step 3: Add Environment Variables

Click **"+ New Variable"** for each of these:

#### Variable 1:
```
Name:  SHOPIFY_STORE_DOMAIN
Value: your-store.myshopify.com
```
Click "Add"

#### Variable 2:
```
Name:  SHOPIFY_API_KEY
Value: your-api-key
```
Click "Add"

#### Variable 3:
```
Name:  SHOPIFY_ADMIN_ACCESS_TOKEN
Value: your-access-token
```
Click "Add"

#### Variable 4:
```
Name:  SHOPIFY_API_VERSION
Value: 2024-07
```
Click "Add"

#### Variable 5:
```
Name:  NODE_ENV
Value: production
```
Click "Add"

#### Variable 6:
```
Name:  PORT
Value: 3000
```
Click "Add"

---

## 🎯 After Adding Variables

Railway will automatically redeploy (wait 30-60 seconds).

Watch the "Deployments" tab - you should see:
- ✅ Initialization
- ✅ Build > Build image  
- ✅ Deploy
- ✅ Post-deploy

When you see **"✓ Success"** - Your backend is live! 🎉

---

## 📋 Get Your Railway URL

1. In the Railway dashboard, look for **"Deployments"** section
2. Click on the successful deployment
3. You'll see a URL like: `https://voyage-app-2025-production.up.railway.app`
4. **Copy this URL!**

---

## 🧪 Test Your Railway Backend

Open terminal and run:

```bash
curl https://YOUR-RAILWAY-URL.up.railway.app/api/shopify/products
```

Replace `YOUR-RAILWAY-URL` with your actual Railway URL.

**If you see product data → SUCCESS! ✅**

---

## 📱 Update Flutter App

Once Railway is working, update your app:

```bash
cd /Users/dhruv/Desktop/Voyage-app-2025

# Update the API URL in constants.dart
# Replace the Vercel URL with your Railway URL
```

I'll do this for you once you give me the Railway URL! 🚀

---

## 🎯 Summary

1. ✅ Fixed Railway configuration (I did this)
2. ⏳ Add 6 environment variables (YOU do this now)
3. ⏳ Wait for deployment to succeed
4. ⏳ Get Railway URL
5. ⏳ Update Flutter app with Railway URL
6. ⏳ Rebuild APK
7. ✅ App works everywhere!

---

## 🆘 If You See Errors

Screenshot the error and show me!

