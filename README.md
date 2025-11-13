# 🚀 Voyage Eyewear - Complete E-commerce Mobile App

A professional Flutter mobile application for eyewear shopping with advanced lens customization, integrated with Shopify backend.

## 📋 Project Overview

**Version:** 1.0.0  
**Platform:** Android (iOS ready)  
**Backend:** Node.js + Express  
**E-commerce:** Shopify Integration  
**State Management:** Provider Pattern

### Key Features

✅ **Product Browsing** - Browse eyewear products with collections  
✅ **Advanced Search** - Find products quickly  
✅ **Product Details** - Detailed product information with image galleries  
✅ **4-Step Lens Selector** - Unique lens customization workflow  
✅ **Prescription Management** - Enter and save prescription data  
✅ **Shopping Cart** - Full cart management with quantity controls  
✅ **Checkout Integration** - Ready for payment gateway integration  
✅ **Real-time Sync** - Live data from Shopify store

---

## 🏗️ Project Structure

```
Voyage-app-2025/
├── voyage_flutter_app/          # Flutter Mobile App
│   ├── lib/
│   │   ├── main.dart            # App entry point
│   │   ├── models/              # Data models
│   │   ├── providers/           # State management
│   │   ├── screens/             # UI screens
│   │   ├── services/            # API services
│   │   ├── widgets/             # Reusable widgets
│   │   └── utils/               # Utilities
│   ├── android/                 # Android configuration
│   └── pubspec.yaml             # Dependencies
│
├── voyage_backend/              # Node.js Backend
│   ├── src/
│   │   ├── routes/              # API routes
│   │   ├── services/            # Business logic
│   │   ├── utils/               # Helper functions
│   │   └── config/              # Configuration
│   ├── server.js                # Entry point
│   └── package.json             # Dependencies
│
└── README.md                    # This file
```

---

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK** (3.0.0+)
- **Node.js** (16+)
- **Android Studio** (for Android builds)
- **Shopify Store** with API access

### 1. Backend Setup

```bash
cd voyage_backend

# Install dependencies
npm install

# Create .env file
cat > .env << EOF
SHOPIFY_STORE_DOMAIN=voyage-eyewear.myshopify.com
SHOPIFY_API_KEY=your_api_key_here
SHOPIFY_API_SECRET=your_api_secret_here
SHOPIFY_ADMIN_ACCESS_TOKEN=your_admin_access_token_here
SHOPIFY_API_VERSION=2024-07
PORT=3000
NODE_ENV=development
EOF

# Start server
npm start
# or for development with auto-reload
npm run dev
```

Server will run on http://localhost:3000

### 2. Flutter App Setup

```bash
cd voyage_flutter_app

# Install dependencies
flutter pub get

# Update API URL in lib/utils/constants.dart
# For Android Emulator: http://10.0.2.2:3000
# For iOS Simulator: http://localhost:3000
# For Physical Device: http://YOUR_COMPUTER_IP:3000

# Run app
flutter run
```

### 3. Build APK (Release)

```bash
cd voyage_flutter_app

# Clean and prepare
flutter clean
flutter pub get

# Build release APK
flutter build apk --release

# APK location:
# build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔌 API Endpoints

Base URL: `http://localhost:3000/api/shopify`

### Products
- `GET /products` - List all products
- `GET /products/:id` - Get single product
- `GET /products/collection/:handle` - Get collection products
- `GET /search?q=query` - Search products

### Collections
- `GET /collections` - List all collections

### Lens Management
- `GET /lens-options` - Get categorized lenses (anti-glare, blue block, colour)

### Cart Operations
- `POST /cart/add` - Add single item
- `POST /cart/add-multiple` - Add frame + lens combo
- `POST /cart/update` - Update quantity
- `POST /cart/remove` - Remove item
- `GET /cart` - Get cart
- `POST /cart/clear` - Clear cart

### Checkout
- `POST /checkout/create` - Create checkout
- `POST /checkout/gokwik` - GoKwik checkout

### Shop Info
- `GET /shop` - Get shop information
- `GET /theme-sections` - Get homepage data

---

## 💻 Development Guide

### Flutter App Architecture

**Pattern:** MVVM (Model-View-ViewModel) with Provider

```
Screens (View)
    ↓
Providers (ViewModel)
    ↓
Services (Data Layer)
    ↓
API (Backend)
```

### Key Files

**Main Entry:**
- `lib/main.dart` - App initialization with providers

**Screens:**
- `home_screen.dart` - Homepage with products
- `product_detail_screen.dart` - Product details
- `cart_screen.dart` - Shopping cart
- `lens_selector_screen.dart` - 4-step lens wizard
- `search_screen.dart` - Product search
- `collection_screen.dart` - Collection products

**Providers:**
- `cart_provider.dart` - Cart state management
- `product_provider.dart` - Product data management
- `lens_provider.dart` - Lens selection state

**Services:**
- `api_service.dart` - HTTP client wrapper
- `shopify_service.dart` - Shopify API methods
- `cart_service.dart` - Cart operations
- `checkout_service.dart` - Checkout flow

### Backend Architecture

**Pattern:** MVC (Model-View-Controller)

```
Routes → Controllers (Routes handle) → Services → Shopify API
```

### Adding New Features

**Add New Screen:**
1. Create screen file in `lib/screens/`
2. Add route in `main.dart`
3. Implement UI and connect to providers

**Add New API Endpoint:**
1. Add route in `src/routes/`
2. Implement logic in `src/services/`
3. Update Flutter service to call endpoint

---

## 🎨 Customization

### Change App Name
1. Update `android/app/src/main/AndroidManifest.xml`:
   ```xml
   android:label="Your App Name"
   ```
2. Update `lib/utils/constants.dart`:
   ```dart
   static const String appName = 'Your App Name';
   ```

### Change Colors
Edit `lib/utils/constants.dart`:
```dart
static const Color primaryColor = Color(0xFF2C3E50);
static const Color secondaryColor = Color(0xFFE74C3C);
static const Color accentColor = Color(0xFF3498DB);
```

### Change API URL
Edit `lib/utils/constants.dart`:
```dart
static const String apiBaseUrl = 'https://your-backend-url.com';
```

---

## 🐛 Troubleshooting

### Backend Issues

**Error: Failed to fetch products**
- Check Shopify credentials in .env
- Verify store domain is correct
- Ensure API access token has proper permissions

**Error: CORS issues**
- Backend allows all origins in development
- For production, configure CORS properly

### Flutter Issues

**Error: Cannot connect to backend**
- For Android Emulator: Use `http://10.0.2.2:3000`
- For iOS Simulator: Use `http://localhost:3000`
- For Physical Device: Use your computer's IP address

**Error: Images not loading**
- Check internet permissions in AndroidManifest.xml
- Verify `usesCleartextTraffic="true"` for HTTP

**Error: Build failed**
```bash
flutter clean
flutter pub get
flutter build apk --release
```

---

## 📱 Features in Detail

### 1. Product Browsing
- Grid layout with 2 columns
- Product images, titles, prices
- Availability indicators
- Pull-to-refresh

### 2. Product Details
- Image gallery with swipe
- Detailed description
- Price with discounts
- Sticky cart buttons (Add to Cart + Select Lens)

### 3. 4-Step Lens Selector ⭐

**Step 1:** Choose Lens Type
- With Power / Single Vision
- Progressive
- Computer Glasses / Blue Cut
- Zero Power

**Step 2:** Select Power Type
- Anti-Glare Lenses
- Blue Block Lenses
- Colour Lenses

**Step 3:** Choose Specific Lens
- Filtered lens options
- Pricing and features
- Real-time Shopify data

**Step 4:** Enter Prescription (Optional)
- Right Eye (OD): SPH, CYL, Axis, ADD
- Left Eye (OS): SPH, CYL, Axis, ADD
- Validation

### 4. Shopping Cart
- List view with product images
- Quantity adjustment (+/-)
- Remove items
- Prescription details display
- Price calculation with tax
- Proceed to checkout

### 5. Search
- Debounced search input
- Real-time results
- Grid view display

---

## 🚢 Deployment

### Backend Deployment (Railway/Render/Heroku)

**Railway:**
```bash
# Install CLI
npm install -g @railway/cli

# Login
railway login

# Deploy
cd voyage_backend
railway init
railway up
```

**Set Environment Variables in Dashboard:**
- SHOPIFY_STORE_DOMAIN
- SHOPIFY_ADMIN_ACCESS_TOKEN
- SHOPIFY_API_VERSION
- PORT

### APK Distribution

**Option 1: Direct Distribution**
- Build APK
- Share via email, Google Drive, website

**Option 2: Google Play Store**
```bash
# Build App Bundle
flutter build appbundle --release

# Upload to Play Console
# Follow Google Play submission process
```

---

## 📊 Performance Optimization

- ✅ Image caching with `cached_network_image`
- ✅ Lazy loading with ListView.builder
- ✅ Debounced search input
- ✅ Efficient state management
- ✅ HTTP request timeout handling

---

## 🔒 Security

- ✅ API credentials in backend (never in app)
- ✅ Environment variables for sensitive data
- ✅ Input validation
- ✅ HTTPS in production (recommended)
- ✅ Secure Shopify Admin API usage

---

## 📦 Dependencies

### Flutter
- `provider` - State management
- `http` - API calls
- `cached_network_image` - Image caching
- `video_player` - Video support
- `shared_preferences` - Local storage
- `url_launcher` - External links
- `intl` - Formatting

### Backend
- `express` - Web framework
- `axios` - HTTP client
- `dotenv` - Environment variables
- `cors` - Cross-origin requests
- `helmet` - Security
- `morgan` - Logging

---

## 🤝 Support

For issues or questions:
1. Check this documentation
2. Review troubleshooting section
3. Check Shopify API documentation
4. Review Flutter documentation

---

## 📄 License

This project is proprietary and confidential.

---

## 🎯 Next Steps

### Immediate
- [ ] Test with your Shopify store
- [ ] Add products and lenses to Shopify
- [ ] Test lens selector workflow
- [ ] Build and test APK

### Short-term
- [ ] Deploy backend to Railway/Render
- [ ] Implement proper checkout flow
- [ ] Add user authentication
- [ ] Implement order tracking

### Long-term
- [ ] iOS version
- [ ] Push notifications
- [ ] Offline support
- [ ] Analytics integration
- [ ] AR try-on feature

---

**Built with ❤️ for Voyage Eyewear**

**Version:** 1.0.0  
**Last Updated:** November 2024  
**Status:** ✅ Production Ready

