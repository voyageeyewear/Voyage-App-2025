# 📖 Voyage Eyewear - Complete Setup Guide

Step-by-step instructions to get your Voyage Eyewear app running.

---

## ✅ Prerequisites Checklist

Before starting, ensure you have:

- [ ] **Flutter SDK** installed (3.0.0 or higher)
  ```bash
  flutter --version
  ```
- [ ] **Node.js** installed (16 or higher)
  ```bash
  node --version
  npm --version
  ```
- [ ] **Android Studio** installed (for Android builds)
- [ ] **VS Code** or **Android Studio** (recommended IDEs)
- [ ] **Git** installed
- [ ] **Shopify Store** with admin access

---

## 🎯 Step 1: Backend Setup (5-10 minutes)

### 1.1 Navigate to Backend Directory
```bash
cd /Users/dhruv/Desktop/Voyage-app-2025/voyage_backend
```

### 1.2 Install Dependencies
```bash
npm install
```

This will install:
- express
- axios
- dotenv
- cors
- helmet
- morgan

### 1.3 Configure Environment Variables

**Option A: Use Existing Configuration (Recommended)**

The backend is already configured with your Shopify credentials in `src/config/shopify.config.js`.

**Option B: Create .env File (Production)**

Create `.env` file in `voyage_backend/` directory:

```bash
cat > .env << 'EOF'
SHOPIFY_STORE_DOMAIN=voyage-eyewear.myshopify.com
SHOPIFY_API_KEY=your_api_key_here
SHOPIFY_API_SECRET=your_api_secret_here
SHOPIFY_ADMIN_ACCESS_TOKEN=your_admin_access_token_here
SHOPIFY_API_VERSION=2024-07
PORT=3000
NODE_ENV=development
EOF
```

### 1.4 Start Backend Server
```bash
npm start
```

You should see:
```
=================================
🚀 Voyage Backend Server Running
📍 Port: 3000
🌍 Environment: development
🏪 Shopify Store: voyage-eyewear.myshopify.com
=================================
```

### 1.5 Test Backend
Open browser and visit: http://localhost:3000/health

You should see:
```json
{
  "status": "ok",
  "timestamp": "2024-11-13T...",
  "shopify": "voyage-eyewear.myshopify.com"
}
```

✅ **Backend is ready!**

---

## 📱 Step 2: Flutter App Setup (5-10 minutes)

### 2.1 Navigate to Flutter Directory
```bash
cd /Users/dhruv/Desktop/Voyage-app-2025/voyage_flutter_app
```

### 2.2 Install Flutter Dependencies
```bash
flutter pub get
```

This will install all required packages from `pubspec.yaml`.

### 2.3 Configure API URL

Edit `lib/utils/constants.dart`:

Find this line:
```dart
static const String apiBaseUrl = 'http://localhost:3000';
```

**Change based on your setup:**

**For Android Emulator:**
```dart
static const String apiBaseUrl = 'http://10.0.2.2:3000';
```

**For iOS Simulator:**
```dart
static const String apiBaseUrl = 'http://localhost:3000';
```

**For Physical Device:**
```dart
static const String apiBaseUrl = 'http://YOUR_COMPUTER_IP:3000';
```

To find your computer's IP:
- **Mac/Linux:** `ifconfig | grep inet`
- **Windows:** `ipconfig`

### 2.4 Run Flutter Doctor
```bash
flutter doctor
```

Fix any issues reported (especially Android licenses).

### 2.5 Run the App

**Option A: Using Command Line**
```bash
flutter run
```

**Option B: Using VS Code**
1. Open project in VS Code
2. Press F5 or click "Run → Start Debugging"

**Option C: Using Android Studio**
1. Open project in Android Studio
2. Click the green play button

✅ **App is running!**

---

## 🏗️ Step 3: Build Release APK (10-15 minutes)

### 3.1 Update Version (Optional)

Edit `pubspec.yaml`:
```yaml
version: 1.0.0+1  # Change to 1.0.0+2 for updates
```

### 3.2 Clean Project
```bash
cd /Users/dhruv/Desktop/Voyage-app-2025/voyage_flutter_app
flutter clean
flutter pub get
```

### 3.3 Build APK
```bash
flutter build apk --release
```

This will take 3-5 minutes.

### 3.4 Locate APK

APK location:
```
/Users/dhruv/Desktop/Voyage-app-2025/voyage_flutter_app/build/app/outputs/flutter-apk/app-release.apk
```

### 3.5 Rename APK (Optional)
```bash
cp build/app/outputs/flutter-apk/app-release.apk ../Voyage-v1.0.0.apk
```

✅ **APK ready for distribution!**

---

## 🚀 Step 4: Testing the App (15-20 minutes)

### 4.1 Test Product Browsing
1. Launch app
2. Verify products load on homepage
3. Click on a product
4. Check product details display correctly

### 4.2 Test Lens Selector
1. Open a product
2. Click "Select Lens" button
3. Complete all 4 steps:
   - Step 1: Choose lens type (e.g., "With Power")
   - Step 2: Select power type (e.g., "Anti-Glare Lenses")
   - Step 3: Choose a specific lens
   - Step 4: Enter prescription (optional)
4. Click "Add to Cart"
5. Verify both frame and lens are added

### 4.3 Test Cart
1. Navigate to cart (top-right icon)
2. Verify items display correctly
3. Test quantity adjustment (+/-)
4. Test remove item
5. Check price calculation

### 4.4 Test Search
1. Click search icon
2. Enter product name
3. Verify results display

### 4.5 Test Collections
1. Click on a category (e.g., "Men")
2. Verify collection products load
3. Test navigation back

✅ **All features working!**

---

## 🌐 Step 5: Deploy Backend (Optional)

### Railway Deployment

**5.1 Create Railway Account**
- Visit: https://railway.app
- Sign up with GitHub

**5.2 Install Railway CLI**
```bash
npm install -g @railway/cli
```

**5.3 Login**
```bash
railway login
```

**5.4 Deploy**
```bash
cd /Users/dhruv/Desktop/Voyage-app-2025/voyage_backend
railway init
railway up
```

**5.5 Set Environment Variables**

In Railway dashboard:
- Go to your project
- Click "Variables"
- Add all variables from .env

**5.6 Get Production URL**

Railway will provide a URL like:
```
https://voyage-backend-production.up.railway.app
```

**5.7 Update Flutter App**

Edit `lib/utils/constants.dart`:
```dart
static const String apiBaseUrl = 'https://your-railway-url.up.railway.app';
```

**5.8 Rebuild APK**
```bash
flutter clean
flutter pub get
flutter build apk --release
```

✅ **Production deployment complete!**

---

## 🔧 Common Issues & Solutions

### Issue 1: Backend Not Starting

**Error:** `Cannot find module 'express'`

**Solution:**
```bash
cd voyage_backend
rm -rf node_modules package-lock.json
npm install
```

### Issue 2: Flutter App Cannot Connect

**Error:** `Failed to load products: Network error`

**Solutions:**
1. Check backend is running (http://localhost:3000/health)
2. Update API URL in constants.dart
3. For Android Emulator: Use `http://10.0.2.2:3000`
4. For Physical Device: Use your computer's IP

### Issue 3: Images Not Loading

**Error:** Images show error icon

**Solutions:**
1. Check internet connection
2. Verify AndroidManifest.xml has:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   <application android:usesCleartextTraffic="true">
   ```

### Issue 4: No Products Showing

**Error:** Empty product list

**Solutions:**
1. Check Shopify store has products
2. Verify API credentials are correct
3. Check backend logs for errors
4. Test backend endpoint: http://localhost:3000/api/shopify/products

### Issue 5: APK Build Fails

**Error:** Build fails during compilation

**Solutions:**
```bash
flutter clean
flutter pub get
flutter doctor
flutter build apk --release --no-shrink
```

### Issue 6: Lens Options Not Loading

**Error:** No lenses in selector

**Solutions:**
1. Add products with type "Lens" in Shopify
2. Tag products with "lens", "antiglare", "blueblock", or "colour"
3. Check backend: http://localhost:3000/api/shopify/lens-options

---

## 📊 Verification Checklist

Before considering setup complete, verify:

### Backend
- [ ] Server starts without errors
- [ ] Health endpoint responds (http://localhost:3000/health)
- [ ] Products endpoint returns data (http://localhost:3000/api/shopify/products)
- [ ] No console errors in terminal

### Flutter App
- [ ] App builds and runs
- [ ] Homepage loads products
- [ ] Product details open
- [ ] Lens selector works (all 4 steps)
- [ ] Cart functionality works
- [ ] Search returns results
- [ ] No red errors in console

### Release APK
- [ ] APK builds successfully
- [ ] APK installs on device
- [ ] App opens without crashes
- [ ] All features work in release build

---

## 🎯 Next Actions

### Immediate (Today)
1. ✅ Setup backend
2. ✅ Run Flutter app
3. ✅ Test all features
4. ✅ Build APK

### Short-term (This Week)
1. Add your actual products to Shopify
2. Add lens products with proper tags
3. Test with real data
4. Share APK with team for testing

### Medium-term (This Month)
1. Deploy backend to production
2. Customize colors and branding
3. Add more product images
4. Integrate payment gateway

---

## 📞 Need Help?

### Documentation
- Main README: See `/README.md`
- Flutter Docs: https://flutter.dev/docs
- Shopify API: https://shopify.dev/docs

### Debug Logs

**Backend Logs:**
```bash
cd voyage_backend
npm start
# Watch terminal for errors
```

**Flutter Logs:**
```bash
cd voyage_flutter_app
flutter run --verbose
```

### Common Commands Reference

**Backend:**
```bash
npm start          # Start server
npm run dev        # Start with auto-reload
npm install        # Install dependencies
```

**Flutter:**
```bash
flutter run              # Run app
flutter build apk        # Build APK
flutter clean            # Clean build files
flutter pub get          # Get dependencies
flutter doctor           # Check setup
```

---

## ✅ Setup Complete!

Congratulations! Your Voyage Eyewear app is now ready.

**What you have:**
- ✅ Working Flutter mobile app
- ✅ Node.js backend with Shopify integration
- ✅ 4-step lens selector
- ✅ Shopping cart functionality
- ✅ Release APK ready for distribution

**Next steps:**
1. Add your products to Shopify
2. Customize the app colors/branding
3. Test thoroughly
4. Deploy backend to production
5. Distribute APK to users

---

**Need to start over?**

Run this to reset everything:
```bash
cd /Users/dhruv/Desktop/Voyage-app-2025/voyage_backend
rm -rf node_modules
npm install

cd ../voyage_flutter_app
flutter clean
flutter pub get
```

**Happy coding! 🚀**

