# Fix Vercel Deployment - API Not Working

## 🔴 Current Problem

Your Vercel deployment is live but returning **404 errors** for API endpoints.

**Test Result:**
```
https://voyage-app-2025.vercel.app/api/shopify/products
→ 404 NOT FOUND
```

---

## ✅ Solution: Configure Vercel Properly

### **Step 1: Add Environment Variables to Vercel**

1. Go to: https://vercel.com/voyageeyewears-projects/voyage-app-2025
2. Click **"Settings"** tab
3. Click **"Environment Variables"** (left sidebar)
4. Add these variables:

```
SHOPIFY_STORE_DOMAIN = your-store.myshopify.com
SHOPIFY_API_KEY = your-api-key
SHOPIFY_ADMIN_ACCESS_TOKEN = your-access-token
SHOPIFY_API_VERSION = 2024-07
NODE_ENV = production
```

5. Click **"Save"** for each variable

---

### **Step 2: Verify vercel.json Configuration**

Make sure you have this file in your backend:

**File:** `voyage_backend/vercel.json`

```json
{
  "version": 2,
  "builds": [
    {
      "src": "server.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/api/(.*)",
      "dest": "/server.js"
    },
    {
      "src": "/(.*)",
      "dest": "/server.js"
    }
  ],
  "env": {
    "NODE_ENV": "production"
  }
}
```

---

### **Step 3: Redeploy**

After adding environment variables:

1. Go to **"Deployments"** tab on Vercel
2. Click the **3 dots** (⋯) on the latest deployment
3. Click **"Redeploy"**
4. Wait for deployment to complete

---

### **Step 4: Test the API**

After redeployment, test:

```bash
curl https://voyage-app-2025.vercel.app/api/shopify/products
```

Should return product data (not 404).

---

## 🎯 Alternative: Use Railway Instead

If Vercel continues to have issues, Railway is easier for Node.js backends:

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Deploy backend
cd voyage_backend
railway init
railway up

# Set environment variables
railway variables set SHOPIFY_STORE_DOMAIN=your-store.myshopify.com
railway variables set SHOPIFY_API_KEY=your-api-key
railway variables set SHOPIFY_ADMIN_ACCESS_TOKEN=your-access-token

# Get URL
railway domain
```

Then update Flutter app with the Railway URL.

---

## 📝 After Fixing

Once the backend works:

1. Test: `curl https://voyage-app-2025.vercel.app/api/shopify/products`
2. Should return JSON product data
3. Rebuild Flutter APK: `bash UPDATE_APK.sh`
4. Install and test on phone

---

## 🆘 Quick Fix

If you want to fix this NOW, run:

```bash
cd /Users/dhruv/Desktop/Voyage-app-2025/voyage_backend
bash RAILWAY_DEPLOY_COMMANDS.sh
```

This will deploy to Railway (easier and more reliable for Node.js backends).

