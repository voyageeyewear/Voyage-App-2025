# ✅ Add API Credentials to Vercel - Step by Step

## 📋 Step 1: Open Vercel Dashboard

1. Go to: **https://vercel.com**
2. Click **"Login"** (top right)
3. Login with your account

---

## 📋 Step 2: Select Your Project

1. You'll see your projects dashboard
2. Click on: **"voyage-app-2025"** project
3. This opens the project page

---

## 📋 Step 3: Go to Settings

1. At the top, you'll see tabs: **Overview | Deployments | Analytics | Settings**
2. Click **"Settings"** tab
3. Wait for settings page to load

---

## 📋 Step 4: Open Environment Variables

1. On the left sidebar, find **"Environment Variables"**
2. Click **"Environment Variables"**
3. You'll see a page with a form to add variables

---

## 📋 Step 5: Add Each Variable

For EACH variable below, do this:

### **Variable 1: SHOPIFY_STORE_DOMAIN**

1. In the **"Key"** field, type: `SHOPIFY_STORE_DOMAIN`
2. In the **"Value"** field, type: `your-store.myshopify.com`
3. Under **"Environment"**, check: ✅ Production, ✅ Preview, ✅ Development
4. Click **"Save"**

### **Variable 2: SHOPIFY_API_KEY**

1. Click **"Add Another"** or the **"+ Add"** button
2. In the **"Key"** field, type: `SHOPIFY_API_KEY`
3. In the **"Value"** field, type: `your-api-key`
4. Under **"Environment"**, check: ✅ Production, ✅ Preview, ✅ Development
5. Click **"Save"**

### **Variable 3: SHOPIFY_ADMIN_ACCESS_TOKEN**

1. Click **"Add Another"** or the **"+ Add"** button
2. In the **"Key"** field, type: `SHOPIFY_ADMIN_ACCESS_TOKEN`
3. In the **"Value"** field, type: `your-access-token`
4. Under **"Environment"**, check: ✅ Production, ✅ Preview, ✅ Development
5. Click **"Save"**

### **Variable 4: SHOPIFY_API_VERSION**

1. Click **"Add Another"** or the **"+ Add"** button
2. In the **"Key"** field, type: `SHOPIFY_API_VERSION`
3. In the **"Value"** field, type: `2024-07`
4. Under **"Environment"**, check: ✅ Production, ✅ Preview, ✅ Development
5. Click **"Save"**

### **Variable 5: NODE_ENV**

1. Click **"Add Another"** or the **"+ Add"** button
2. In the **"Key"** field, type: `NODE_ENV`
3. In the **"Value"** field, type: `production`
4. Under **"Environment"**, check: ✅ Production, ✅ Preview, ✅ Development
5. Click **"Save"**

### **Variable 6: PORT**

1. Click **"Add Another"** or the **"+ Add"** button
2. In the **"Key"** field, type: `PORT`
3. In the **"Value"** field, type: `3000`
4. Under **"Environment"**, check: ✅ Production, ✅ Preview, ✅ Development
5. Click **"Save"**

---

## 📋 Step 6: Verify All Variables

After adding all 6 variables, you should see:

```
SHOPIFY_STORE_DOMAIN = your-store.myshopify.com
SHOPIFY_API_KEY = your-api-key
SHOPIFY_ADMIN_ACCESS_TOKEN = your-access-token
SHOPIFY_API_VERSION = 2024-07
NODE_ENV = production
PORT = 3000
```

All showing **"Production, Preview, Development"** ✅

---

## 📋 Step 7: Redeploy the Project

1. Click **"Deployments"** tab (at the top)
2. Find the most recent deployment (top of the list)
3. Click the **3 dots** (⋯) on the right side
4. Click **"Redeploy"**
5. A popup will appear: Click **"Redeploy"** button again
6. Wait 30-60 seconds for deployment to complete
7. You'll see: **"✓ Deployment completed"**

---

## 📋 Step 8: Test the API

Open a new terminal and test:

```bash
curl https://voyage-app-2025.vercel.app/api/shopify/products
```

**Expected Result:**
```json
{
  "products": [
    {
      "id": "...",
      "title": "Aurix Smart Glasses",
      "price": 2999,
      ...
    }
  ]
}
```

**If you see product data → SUCCESS! ✅**

**If you still see 404 → Continue to Step 9**

---

## 📋 Step 9: Check vercel.json (If Still Not Working)

1. Make sure you have this file in your backend:

**File:** `/Users/dhruv/Desktop/Voyage-app-2025/voyage_backend/vercel.json`

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
  ]
}
```

2. If you don't have this file, I'll create it for you
3. Then push to GitHub and Vercel will auto-redeploy

---

## 📋 Step 10: Update Flutter App (After API Works)

Once the API is working, rebuild the APK:

```bash
cd /Users/dhruv/Desktop/Voyage-app-2025/voyage_flutter_app
flutter clean
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk /Users/dhruv/Desktop/Voyage-Eyewear.apk
```

Then install:

```bash
adb install -r /Users/dhruv/Desktop/Voyage-Eyewear.apk
```

---

## 🎯 Summary Checklist

- [ ] Logged into Vercel
- [ ] Opened voyage-app-2025 project
- [ ] Went to Settings → Environment Variables
- [ ] Added all 6 variables
- [ ] Redeployed the project
- [ ] Tested API with curl command
- [ ] Rebuilt Flutter APK
- [ ] Installed on phone
- [ ] App works! 🎉

---

## 🆘 If Still Not Working

1. Check Vercel deployment logs:
   - Go to **Deployments** tab
   - Click on latest deployment
   - Click **"View Function Logs"**
   - Look for errors

2. OR use Railway instead (easier):
   ```bash
   cd /Users/dhruv/Desktop/Voyage-app-2025/voyage_backend
   bash RAILWAY_DEPLOY_COMMANDS.sh
   ```

---

## 📞 Need Help?

- Vercel Docs: https://vercel.com/docs/environment-variables
- Let me know if you see any errors!

