# EyeJack System Architecture & Flow Diagrams

## Table of Contents
1. [High-Level System Architecture](#1-high-level-system-architecture)
2. [Data Flow Diagrams](#2-data-flow-diagrams)
3. [User Journey Maps](#3-user-journey-maps)
4. [Component Architecture](#4-component-architecture)
5. [API Request Flow](#5-api-request-flow)
6. [State Management Flow](#6-state-management-flow)
7. [Deployment Architecture](#7-deployment-architecture)

---

## 1. High-Level System Architecture

```
╔══════════════════════════════════════════════════════════════════╗
║                         USER DEVICES                              ║
║                    (Android/iOS Phones)                          ║
╚══════════════════════════════════════════════════════════════════╝
                              │
                              │ HTTPS/REST API
                              │
                              ▼
╔══════════════════════════════════════════════════════════════════╗
║                      FLUTTER MOBILE APP                          ║
║  ┌────────────────────────────────────────────────────────────┐ ║
║  │  Presentation Layer (UI Screens & Widgets)                 │ ║
║  └────────────────────────────────────────────────────────────┘ ║
║  ┌────────────────────────────────────────────────────────────┐ ║
║  │  State Management Layer (Provider Pattern)                 │ ║
║  │  - CartProvider  - ProductProvider  - LensProvider         │ ║
║  └────────────────────────────────────────────────────────────┘ ║
║  ┌────────────────────────────────────────────────────────────┐ ║
║  │  Business Logic Layer (Services)                           │ ║
║  │  - ApiService  - CartService  - CheckoutService            │ ║
║  └────────────────────────────────────────────────────────────┘ ║
║  ┌────────────────────────────────────────────────────────────┐ ║
║  │  Data Layer (Models & Local Storage)                       │ ║
║  │  - Product  - CartItem  - Lens  - SharedPreferences        │ ║
║  └────────────────────────────────────────────────────────────┘ ║
╚══════════════════════════════════════════════════════════════════╝
                              │
                              │ HTTP Requests
                              │ JSON Responses
                              ▼
╔══════════════════════════════════════════════════════════════════╗
║                  NODE.JS MIDDLEWARE LAYER                        ║
║                    (Railway Deployment)                          ║
║                                                                  ║
║  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌───────────┐║
║  │  Express   │  │  Routes    │  │Controllers │  │ Services  │║
║  │  Server    │─▶│  Layer     │─▶│  Layer     │─▶│  Layer    │║
║  └────────────┘  └────────────┘  └────────────┘  └───────────┘║
║                                                                  ║
║  Routes: /api/shopify/*                                         ║
║  - Products, Collections, Cart, Checkout, Lens                  ║
║                                                                  ║
║  Middleware: Authentication, Validation, Error Handling         ║
╚══════════════════════════════════════════════════════════════════╝
                              │
                              │ GraphQL & REST
                              │ API Calls
                              ▼
╔══════════════════════════════════════════════════════════════════╗
║                     SHOPIFY PLATFORM                             ║
║                                                                  ║
║  ┌────────────────┐  ┌────────────────┐  ┌──────────────────┐ ║
║  │  Storefront    │  │  Admin API     │  │  Payment         │ ║
║  │  API (GraphQL) │  │  (REST)        │  │  Processing      │ ║
║  └────────────────┘  └────────────────┘  └──────────────────┘ ║
║                                                                  ║
║  Data Storage:                                                  ║
║  - Products & Variants                                          ║
║  - Collections                                                  ║
║  - Cart & Checkout Sessions                                     ║
║  - Customer Data                                                ║
║  - Orders & Fulfillment                                         ║
╚══════════════════════════════════════════════════════════════════╝
                              │
                              ▼
╔══════════════════════════════════════════════════════════════════╗
║                    EXTERNAL INTEGRATIONS                         ║
║  ┌─────────────────────┐    ┌─────────────────────┐            ║
║  │  GoKwik Payment     │    │  CDN (Images)       │            ║
║  │  Gateway            │    │  eyejack.in         │            ║
║  └─────────────────────┘    └─────────────────────┘            ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 2. Data Flow Diagrams

### 2.1 Product Browsing Flow

```
┌─────────────┐
│    USER     │
│   Opens App │
└──────┬──────┘
       │
       │ 1. Launch
       ▼
┌─────────────────────┐
│  HomeScreen Widget  │
│  (initState)        │
└──────┬──────────────┘
       │
       │ 2. fetchProducts()
       ▼
┌─────────────────────┐
│  ProductProvider    │
│  (State Manager)    │
└──────┬──────────────┘
       │
       │ 3. HTTP GET Request
       ▼
┌─────────────────────────────────────────┐
│  ApiService.get('/api/shopify/products')│
└──────┬──────────────────────────────────┘
       │
       │ 4. Route to Controller
       ▼
┌─────────────────────────────────┐
│  Node.js Middleware             │
│  GET /api/shopify/products      │
└──────┬──────────────────────────┘
       │
       │ 5. Shopify GraphQL Query
       ▼
┌─────────────────────────────────┐
│  Shopify Storefront API         │
│  query { products {...} }       │
└──────┬──────────────────────────┘
       │
       │ 6. JSON Response
       ▼
┌─────────────────────────────────┐
│  Middleware: Parse & Format     │
│  Transform to app schema        │
└──────┬──────────────────────────┘
       │
       │ 7. Return Products Array
       ▼
┌─────────────────────────────────┐
│  Flutter: Product.fromJson()    │
│  Create model instances         │
└──────┬──────────────────────────┘
       │
       │ 8. notifyListeners()
       ▼
┌─────────────────────────────────┐
│  UI Rebuild: GridView.builder   │
│  Render ProductCard widgets     │
└──────┬──────────────────────────┘
       │
       │ 9. Display to User
       ▼
┌─────────────┐
│  USER SEES  │
│  PRODUCTS   │
└─────────────┘
```

### 2.2 Add to Cart Flow (With Lens Selection)

```
USER: Taps "Select Lens"
         │
         ▼
┌────────────────────────┐
│  LensSelectorScreen    │
│  (4-Step Wizard)       │
└────────┬───────────────┘
         │
         ├─ STEP 1: Select Lens Type
         │  (Power/Progressive/Computer/Zero)
         │
         ├─ STEP 2: Select Power Type
         │  (Anti-glare/Blue Block/Colour)
         │  │
         │  └──▶ API: GET /api/shopify/lens-options
         │       │
         │       └──▶ Returns categorized lenses
         │
         ├─ STEP 3: Choose Specific Lens
         │  (Display filtered list)
         │
         ├─ STEP 4: Enter Prescription
         │  (SPH, CYL, Axis, ADD for both eyes)
         │
         ▼
User: Taps "Add to Cart"
         │
         ▼
┌────────────────────────────────────┐
│  CartService.addMultipleItems()    │
│  Prepare request:                  │
│  - Frame product                   │
│  - Selected lens                   │
│  - Prescription data as properties │
└────────┬───────────────────────────┘
         │
         ▼
POST /api/shopify/cart/add-multiple
{
  "items": [
    {
      "variantId": "frame_variant_id",
      "quantity": 1,
      "properties": { "Frame": "Aviator Gold" }
    },
    {
      "variantId": "lens_variant_id",
      "quantity": 1,
      "properties": {
        "Lens Type": "Anti-glare",
        "Right SPH": "-2.00",
        "Right CYL": "-0.50",
        "Right Axis": "180",
        "Left SPH": "-2.25",
        "Left CYL": "-0.75",
        "Left Axis": "175"
      }
    }
  ]
}
         │
         ▼
┌────────────────────────────────┐
│  Shopify: Create Cart Items    │
│  Link frame + lens together    │
└────────┬───────────────────────┘
         │
         ▼
Response: { "cart": {...}, "lineItems": [...] }
         │
         ▼
┌────────────────────────────────┐
│  CartProvider: Update State    │
│  _items.add(...)               │
│  notifyListeners()             │
└────────┬───────────────────────┘
         │
         ▼
┌────────────────────────────────┐
│  UI: Show Success Message      │
│  Navigate back to product page │
│  Update cart badge (2 items)   │
└────────────────────────────────┘
```

### 2.3 Checkout Flow

```
USER: Taps "Proceed to Checkout"
         │
         ▼
┌────────────────────────────────┐
│  CheckoutService.createCheckout│
└────────┬───────────────────────┘
         │
         ▼
POST /api/shopify/checkout/gokwik
{
  "cartId": "cart_123",
  "customerInfo": {
    "email": "user@example.com",
    "phone": "+919876543210"
  }
}
         │
         ▼
┌────────────────────────────────┐
│  Middleware: GoKwik Integration│
│  Create checkout session       │
└────────┬───────────────────────┘
         │
         ▼
Response: { "checkoutUrl": "https://gokwik.co/...", "orderId": "..." }
         │
         ▼
┌────────────────────────────────┐
│  Flutter: url_launcher         │
│  Open WebView with checkout URL│
└────────┬───────────────────────┘
         │
         ▼
┌────────────────────────────────┐
│  USER: Complete Payment        │
│  (GoKwik payment page)         │
└────────┬───────────────────────┘
         │
         ├─ SUCCESS
         │  └──▶ Redirect to success page
         │       Clear cart
         │       Show order confirmation
         │
         └─ FAILURE
            └──▶ Return to cart
                 Show error message
                 Allow retry
```

---

## 3. User Journey Maps

### 3.1 First-Time User Journey

```
┌──────────────┐
│ Install App  │
└──────┬───────┘
       │
       ▼
┌───────────────────────────────┐
│ Launch Screen / Splash        │
│ (Load initial data)           │
└──────┬────────────────────────┘
       │
       ▼
┌───────────────────────────────┐
│ Homepage                      │
│ - Hero Slider (auto-play)    │
│ - Gender Categories           │
│ - Featured Collections        │
│ - Features Section            │
│ - Statistics                  │
│ - Video Demo                  │
│ - FAQ                         │
└──────┬────────────────────────┘
       │
       ├─ Option A: Browse by Gender
       │  └──▶ Men's Collection
       │       └──▶ Product Grid
       │
       ├─ Option B: Search
       │  └──▶ Search Bar
       │       └──▶ Type "aviator"
       │            └──▶ Results Page
       │
       └─ Option C: Browse Collections
          └──▶ Sunglasses Collection
               └──▶ Product Grid
```

### 3.2 Purchase Journey (Power User)

```
Goal: Buy prescription sunglasses

Step 1: Browse Products (2 min)
   └──▶ Open Men's Sunglasses collection
        └──▶ Filter: Price < ₹3000
             └──▶ Sort: Newest first

Step 2: Product Selection (3 min)
   └──▶ Tap product card
        └──▶ View images (swipe gallery)
             └──▶ Read description
                  └──▶ Check measurements
                       └──▶ Review features

Step 3: Lens Configuration (5 min)
   └──▶ Tap "Select Lens" button
        └──▶ Step 1: Choose "With Power"
             └──▶ Step 2: Select "Anti-glare Lenses"
                  └──▶ Step 3: Choose "Premium Anti-glare (₹500)"
                       └──▶ Step 4: Enter prescription
                            - Right SPH: -2.00
                            - Right CYL: -0.50
                            - Right Axis: 180
                            - Left SPH: -2.25
                            - Left CYL: -0.75
                            - Left Axis: 175
                            └──▶ Tap "Add to Cart"

Step 4: Review Cart (1 min)
   └──▶ Navigate to cart
        └──▶ Verify items:
             - Frame (₹2499)
             - Anti-glare Lens (₹500)
             - Prescription details shown
             └──▶ Total: ₹2999

Step 5: Checkout (3 min)
   └──▶ Tap "Proceed to Checkout"
        └──▶ GoKwik page opens
             └──▶ Enter shipping address
                  └──▶ Select payment method
                       └──▶ Complete payment
                            └──▶ Order confirmation

Total Time: ~14 minutes
```

---

## 4. Component Architecture

### 4.1 Flutter App Component Tree

```
MyApp (MaterialApp)
│
├── MultiProvider
│   ├── CartProvider
│   ├── ProductProvider
│   └── LensProvider
│
├── Navigator (Routes)
│   │
│   ├── "/" → HomeScreen
│   │   │
│   │   ├── AppBar
│   │   │   ├── Logo
│   │   │   ├── SearchButton
│   │   │   └── CartBadge
│   │   │
│   │   ├── RefreshIndicator
│   │   │   └── ListView
│   │   │       ├── HeroSlider
│   │   │       │   └── PageView
│   │   │       │       ├── ImageSlide
│   │   │       │       └── VideoSlide
│   │   │       │
│   │   │       ├── GenderCategories
│   │   │       │   └── Row
│   │   │       │       ├── GenderCard (Men)
│   │   │       │       ├── GenderCard (Women)
│   │   │       │       └── GenderCard (Kids)
│   │   │       │
│   │   │       ├── FeaturedCollections
│   │   │       │   └── GridView
│   │   │       │       └── CollectionCard
│   │   │       │
│   │   │       ├── FeaturesSection
│   │   │       ├── StatisticsSection
│   │   │       ├── VideoDemoSection
│   │   │       └── FAQSection
│   │   │
│   │   └── BottomNavigationBar
│   │
│   ├── "/collection/:handle" → CollectionScreen
│   │   │
│   │   ├── AppBar (with back button)
│   │   ├── FilterSortBar
│   │   │   ├── SortDropdown
│   │   │   └── FilterButton
│   │   │
│   │   └── RefreshIndicator
│   │       └── GridView.builder
│   │           └── ProductCard
│   │               ├── CachedNetworkImage
│   │               ├── ProductTitle
│   │               ├── PriceText
│   │               └── QuickAddButton
│   │
│   ├── "/product/:id" → ProductDetailScreen
│   │   │
│   │   ├── AppBar
│   │   ├── Breadcrumb
│   │   │
│   │   ├── ScrollView
│   │   │   ├── ImageGallery
│   │   │   │   ├── MainImage (PageView)
│   │   │   │   └── ThumbnailStrip
│   │   │   │
│   │   │   ├── ProductInfo
│   │   │   │   ├── Title
│   │   │   │   ├── ReviewStars
│   │   │   │   ├── PriceDisplay
│   │   │   │   │   ├── CurrentPrice
│   │   │   │   │   ├── OriginalPrice
│   │   │   │   │   └── DiscountBadge
│   │   │   │   └── TaxInfo
│   │   │   │
│   │   │   ├── CollapsibleDescription
│   │   │   ├── PrescriptionUploadSection
│   │   │   ├── ProductFeaturesWidget
│   │   │   ├── SpecificationsAccordion
│   │   │   ├── ProductVideosSection
│   │   │   └── FAQSection
│   │   │
│   │   └── StickyCartButtons
│   │       ├── AddToCartButton
│   │       └── SelectLensButton
│   │
│   ├── "/lens-selector" → LensSelectorScreen
│   │   │
│   │   └── Stepper
│   │       ├── Step 1: LensTypeSelector
│   │       ├── Step 2: PowerTypeSelector
│   │       ├── Step 3: LensListView
│   │       └── Step 4: PrescriptionForm
│   │           ├── RightEyeFields
│   │           ├── LeftEyeFields
│   │           └── SubmitButton
│   │
│   ├── "/cart" → CartScreen
│   │   │
│   │   ├── AppBar
│   │   ├── ListView.builder
│   │   │   └── CartItemWidget
│   │   │       ├── Image
│   │   │       ├── ItemDetails
│   │   │       ├── PrescriptionInfo (if lens)
│   │   │       ├── QuantitySelector
│   │   │       └── RemoveButton
│   │   │
│   │   └── CheckoutPanel
│   │       ├── SubtotalText
│   │       ├── TaxText
│   │       ├── TotalText
│   │       └── CheckoutButton
│   │
│   └── "/search" → SearchScreen
│       │
│       ├── SearchBar
│       └── GridView (Results)
│           └── ProductCard
```

### 4.2 Backend Component Structure

```
Node.js Server (Express)
│
├── App Initialization (app.js)
│   ├── Middleware Setup
│   │   ├── helmet (security)
│   │   ├── cors (cross-origin)
│   │   ├── morgan (logging)
│   │   ├── express.json (body parsing)
│   │   └── errorHandler (custom)
│   │
│   └── Route Registration
│       ├── /api/shopify/* → shopifyRoutes
│       ├── /health → healthCheck
│       └── /* → 404 handler
│
├── Routes Layer
│   │
│   ├── shopify.routes.js
│   │   ├── GET /theme-sections
│   │   ├── GET /products
│   │   ├── GET /products/:id
│   │   ├── GET /products/collection/:handle
│   │   ├── GET /collections
│   │   ├── GET /shop
│   │   └── GET /search
│   │
│   ├── lens.routes.js
│   │   └── GET /lens-options
│   │
│   ├── cart.routes.js
│   │   ├── POST /cart/add
│   │   ├── POST /cart/add-multiple
│   │   ├── POST /cart/update
│   │   ├── POST /cart/remove
│   │   ├── GET /cart
│   │   └── POST /cart/clear
│   │
│   └── checkout.routes.js
│       ├── POST /checkout/create
│       └── POST /checkout/gokwik
│
├── Controllers Layer
│   │
│   ├── shopify.controller.js
│   │   ├── getProducts()
│   │   ├── getProductById()
│   │   ├── getCollectionProducts()
│   │   └── searchProducts()
│   │
│   ├── lens.controller.js
│   │   └── getLensOptions()
│   │       └── categorizeLens()
│   │
│   ├── cart.controller.js
│   │   ├── addToCart()
│   │   ├── addMultipleToCart()
│   │   ├── updateCart()
│   │   └── removeFromCart()
│   │
│   └── checkout.controller.js
│       ├── createCheckout()
│       └── createGokwikCheckout()
│
├── Services Layer
│   │
│   ├── shopify.service.js
│   │   ├── GraphQL Client
│   │   ├── REST Client
│   │   ├── fetchProducts()
│   │   ├── fetchProduct()
│   │   ├── fetchCollections()
│   │   └── createCart()
│   │
│   └── gokwik.service.js
│       ├── createCheckoutSession()
│       └── verifyPayment()
│
└── Utils
    ├── lens-categorizer.js
    │   └── categorizeLens()
    │
    └── logger.js
        ├── info()
        ├── error()
        └── debug()
```

---

## 5. API Request Flow

### 5.1 Detailed API Call Sequence

```
┌─────────────┐
│ Flutter App │
└──────┬──────┘
       │
       │ 1. User action triggers API call
       │    Example: Load products
       ▼
┌──────────────────┐
│  ApiService      │
│  .get('/products')│
└──────┬───────────┘
       │
       │ 2. Create HTTP request
       │    URL: https://motivated-intuition-production.up.railway.app
       │    Path: /api/shopify/products
       │    Method: GET
       │    Headers: { 'Content-Type': 'application/json' }
       │    Timeout: 30 seconds
       ▼
┌────────────────────────────────┐
│  Network Layer (http package)  │
│  Send request over internet    │
└──────┬─────────────────────────┘
       │
       │ 3. Request reaches Railway server
       ▼
┌────────────────────────────────┐
│  Railway Load Balancer         │
│  Route to Node.js instance     │
└──────┬─────────────────────────┘
       │
       │ 4. Express middleware chain
       ▼
┌────────────────────────────────┐
│  Middleware: helmet            │
│  (Security headers)            │
└──────┬─────────────────────────┘
       ▼
┌────────────────────────────────┐
│  Middleware: cors              │
│  (Check origin)                │
└──────┬─────────────────────────┘
       ▼
┌────────────────────────────────┐
│  Middleware: morgan            │
│  (Log request)                 │
│  → "GET /api/shopify/products" │
└──────┬─────────────────────────┘
       ▼
┌────────────────────────────────┐
│  Route Handler                 │
│  router.get('/products', ...)  │
└──────┬─────────────────────────┘
       │
       │ 5. Call controller
       ▼
┌────────────────────────────────┐
│  shopify.controller.js         │
│  async getProducts(req, res)   │
└──────┬─────────────────────────┘
       │
       │ 6. Call service
       ▼
┌────────────────────────────────┐
│  shopify.service.js            │
│  fetchProducts()               │
└──────┬─────────────────────────┘
       │
       │ 7. Make Shopify API call
       │    GraphQL Query:
       │    {
       │      products(first: 50) {
       │        edges {
       │          node {
       │            id, title, handle,
       │            images { url },
       │            priceRange { ... }
       │          }
       │        }
       │      }
       │    }
       ▼
┌────────────────────────────────┐
│  Shopify Storefront API        │
│  Process GraphQL query         │
│  Fetch from database           │
└──────┬─────────────────────────┘
       │
       │ 8. Return data to service
       │    { "data": { "products": [...] } }
       ▼
┌────────────────────────────────┐
│  shopify.service.js            │
│  Transform response:           │
│  - Flatten edges/nodes         │
│  - Format images               │
│  - Parse prices                │
└──────┬─────────────────────────┘
       │
       │ 9. Return to controller
       ▼
┌────────────────────────────────┐
│  shopify.controller.js         │
│  res.json({ products: data })  │
└──────┬─────────────────────────┘
       │
       │ 10. HTTP Response
       │     Status: 200
       │     Body: JSON array of products
       ▼
┌────────────────────────────────┐
│  Network Layer                 │
│  Send response back            │
└──────┬─────────────────────────┘
       │
       │ 11. Response arrives at Flutter
       ▼
┌────────────────────────────────┐
│  ApiService                    │
│  Parse JSON response           │
└──────┬─────────────────────────┘
       │
       │ 12. Convert to models
       ▼
┌────────────────────────────────┐
│  Product.fromJson()            │
│  Create Product instances      │
└──────┬─────────────────────────┘
       │
       │ 13. Update state
       ▼
┌────────────────────────────────┐
│  ProductProvider               │
│  _products = fetchedProducts   │
│  notifyListeners()             │
└──────┬─────────────────────────┘
       │
       │ 14. Trigger UI rebuild
       ▼
┌────────────────────────────────┐
│  UI Widgets                    │
│  Rebuild with new data         │
│  Display products to user      │
└────────────────────────────────┘

Total time: 500-1500ms (depending on network)
```

---

## 6. State Management Flow

### 6.1 Provider Pattern Implementation

```
┌─────────────────────────────────────────────────┐
│            Provider Pattern Flow                │
└─────────────────────────────────────────────────┘

1. APP INITIALIZATION
   ──────────────────
   main.dart:
   runApp(
     MultiProvider(
       providers: [
         ChangeNotifierProvider(create: (_) => CartProvider()),
         ChangeNotifierProvider(create: (_) => ProductProvider()),
         ChangeNotifierProvider(create: (_) => LensProvider()),
       ],
       child: MyApp(),
     )
   );

2. PROVIDER CLASS STRUCTURE
   ────────────────────────
   class CartProvider extends ChangeNotifier {
     // Private state
     List<CartItem> _items = [];
     
     // Public getters
     List<CartItem> get items => _items;
     int get itemCount => _items.length;
     double get totalPrice => _items.fold(0, (sum, item) => ...);
     
     // Methods that modify state
     void addItem(CartItem item) {
       _items.add(item);
       notifyListeners();  // ← Triggers rebuild
     }
     
     void removeItem(String id) {
       _items.removeWhere((item) => item.id == id);
       notifyListeners();  // ← Triggers rebuild
     }
   }

3. CONSUMING PROVIDER IN WIDGETS
   ─────────────────────────────
   
   Option A: Consumer Widget (rebuilds on change)
   ──────────────────────────────────────────────
   Consumer<CartProvider>(
     builder: (context, cart, child) {
       return Text('Items: ${cart.itemCount}');
       // This widget rebuilds when notifyListeners() is called
     },
   )
   
   Option B: Provider.of (rebuild entire widget)
   ────────────────────────────────────────────
   class CartScreen extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       final cart = Provider.of<CartProvider>(context);
       // Entire widget rebuilds on cart changes
       
       return ListView.builder(
         itemCount: cart.items.length,
         itemBuilder: (context, index) {
           return CartItemWidget(cart.items[index]);
         },
       );
     }
   }
   
   Option C: context.watch (Flutter 2.0+)
   ────────────────────────────────────
   final cart = context.watch<CartProvider>();
   return Text('Total: ₹${cart.totalPrice}');
   
   Option D: context.read (no rebuild, one-time read)
   ─────────────────────────────────────────────────
   onPressed: () {
     context.read<CartProvider>().addItem(item);
     // Doesn't rebuild this widget
   }

4. STATE CHANGE FLOW
   ──────────────────
   
   User Action
       │
       └──▶ Widget calls provider method
            │
            └──▶ Provider.addItem(item)
                 │
                 ├──▶ Modify internal state: _items.add(item)
                 │
                 └──▶ Call notifyListeners()
                      │
                      └──▶ Flutter framework notifies all listeners
                           │
                           └──▶ All Consumer/Provider.of widgets rebuild
                                │
                                └──▶ UI updates with new data

5. MULTIPLE PROVIDER INTERACTION
   ────────────────────────────
   
   class LensSelectorScreen extends StatelessWidget {
     void addToCart(BuildContext context) {
       // Read from LensProvider (no rebuild)
       final lensProvider = context.read<LensProvider>();
       final selectedLens = lensProvider.selectedLens;
       
       // Read from ProductProvider (no rebuild)
       final productProvider = context.read<ProductProvider>();
       final currentProduct = productProvider.currentProduct;
       
       // Write to CartProvider (triggers rebuild)
       context.read<CartProvider>().addMultipleItems([
         CartItem.fromProduct(currentProduct),
         CartItem.fromLens(selectedLens),
       ]);
       
       // Clear lens selection
       lensProvider.clearSelection();
     }
   }
```

### 6.2 State Lifecycle

```
App Launch
    │
    ▼
[Create Provider Instances]
    │
    ├──▶ CartProvider()
    │    └── _items = []
    │    └── Initialize from local storage (optional)
    │
    ├──▶ ProductProvider()
    │    └── _products = []
    │    └── _currentProduct = null
    │
    └──▶ LensProvider()
         └── _selectedLens = null
         └── _prescriptionData = null
    │
    ▼
[Widgets Register as Listeners]
    │
    ├──▶ HomeScreen → Consumer<ProductProvider>
    ├──▶ CartScreen → Consumer<CartProvider>
    ├──▶ ProductDetailScreen → Consumer<ProductProvider>
    └──▶ LensSelectorScreen → Consumer<LensProvider>
    │
    ▼
[User Interacts]
    │
    └──▶ Example: Add to Cart
         │
         ▼
    [CartProvider.addItem() called]
         │
         ├──▶ _items.add(newItem)
         ├──▶ notifyListeners()
         │    │
         │    └──▶ All registered listeners notified
         │         │
         │         ├──▶ CartScreen rebuilds
         │         ├──▶ AppBar cart badge rebuilds
         │         └──▶ Other consumers rebuild
         │
         └──▶ Optional: Persist to local storage
              └──▶ SharedPreferences.setString('cart', json)
    │
    ▼
[App Closed]
    │
    └──▶ Providers disposed
         └── Save state if needed
```

---

## 7. Deployment Architecture

### 7.1 Railway Deployment Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    DEVELOPMENT MACHINE                       │
│                                                              │
│  Developer makes changes:                                   │
│  - Edit middleware code                                     │
│  - Update dependencies                                      │
│  - Test locally                                             │
│                                                              │
│  $ git add .                                                │
│  $ git commit -m "Update product endpoints"                │
│  $ git push origin main                                     │
│                                                              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ Push to GitHub
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                      GITHUB REPOSITORY                       │
│                  voyageeyewear/eyejack                       │
│                                                              │
│  - Receives push event                                      │
│  - Triggers webhook to Railway                              │
│                                                              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ Webhook notification
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    RAILWAY PLATFORM                          │
│                                                              │
│  1. Detect Changes                                          │
│     └──▶ New commit on main branch                         │
│                                                              │
│  2. Build Phase                                             │
│     ├──▶ Clone repository                                   │
│     ├──▶ Detect Node.js project                            │
│     ├──▶ Read package.json                                 │
│     ├──▶ Run: npm install                                  │
│     ├──▶ Install all dependencies                          │
│     └──▶ Create build artifact                             │
│                                                              │
│  3. Test Phase (if configured)                              │
│     └──▶ Run: npm test                                     │
│                                                              │
│  4. Deploy Phase                                            │
│     ├──▶ Stop old container                                │
│     ├──▶ Start new container                               │
│     ├──▶ Load environment variables from Railway dashboard  │
│     │    - SHOPIFY_STORE_DOMAIN                            │
│     │    - SHOPIFY_ADMIN_ACCESS_TOKEN                      │
│     │    - SHOPIFY_STOREFRONT_ACCESS_TOKEN                 │
│     │    - SHOPIFY_API_VERSION                             │
│     │    - PORT                                             │
│     ├──▶ Run: npm start                                    │
│     └──▶ Server starts on assigned port                    │
│                                                              │
│  5. Health Check                                            │
│     └──▶ Send GET request to /health                       │
│          ├── Success → Mark deployment as healthy           │
│          └── Failure → Rollback to previous version        │
│                                                              │
│  6. Assign Domain                                           │
│     └──▶ motivated-intuition-production.up.railway.app     │
│                                                              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ Deployment complete (60-90 seconds)
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                   PRODUCTION SERVER                          │
│                                                              │
│  Container running Node.js + Express                        │
│  - Memory: 512MB-1GB                                        │
│  - CPU: Shared                                              │
│  - Auto-restart on failure                                  │
│  - Load balancing enabled                                   │
│  - SSL/HTTPS automatic                                      │
│                                                              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ API requests
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    FLUTTER MOBILE APP                        │
│            (Installed on user devices)                       │
│                                                              │
│  Makes API calls to:                                        │
│  https://motivated-intuition-production.up.railway.app      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 7.2 APK Distribution Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    DEVELOPMENT MACHINE                       │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ Developer updates Flutter app
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│  1. Update Version                                            │
│     pubspec.yaml:                                            │
│     version: 6.0.1+61  # versionName+buildNumber            │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│  2. Build Release APK                                         │
│     $ flutter clean                                          │
│     $ flutter pub get                                        │
│     $ flutter build apk --release                           │
│                                                              │
│     Build process:                                          │
│     ├──▶ Compile Dart to native code                       │
│     ├──▶ Bundle assets                                     │
│     ├──▶ Sign APK with release key                         │
│     └──▶ Optimize and compress                             │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│  3. APK Generated                                             │
│     Location: build/app/outputs/flutter-apk/app-release.apk │
│     Size: ~52MB                                              │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│  4. Distribution Options                                      │
│                                                              │
│  Option A: Manual Distribution                              │
│  ────────────────────────────                               │
│  └──▶ Rename: Eyejack-v6.0.1-Build61.apk                   │
│  └──▶ Share via:                                           │
│       ├── Email                                             │
│       ├── Google Drive                                      │
│       ├── Dropbox                                           │
│       └── Direct download link                              │
│                                                              │
│  Option B: Google Play Store (Future)                       │
│  ────────────────────────────────────                       │
│  └──▶ Build App Bundle: flutter build appbundle            │
│  └──▶ Upload to Play Console                               │
│  └──▶ Review process (1-7 days)                            │
│  └──▶ Published to store                                   │
│                                                              │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│                       END USERS                               │
│                                                              │
│  Android Devices:                                           │
│  ├──▶ Download APK                                          │
│  ├──▶ Enable "Install from Unknown Sources"                │
│  ├──▶ Install app                                           │
│  └──▶ Launch Eyejack                                        │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### 7.3 Complete System Deployment Map

```
┌─────────────────────────────────────────────────────────────────┐
│                         PRODUCTION ECOSYSTEM                     │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────┐         ┌──────────────────┐
│   Android Users  │         │    iOS Users     │
│   (Play Store or │         │  (App Store or   │
│   Direct APK)    │         │   TestFlight)    │
└────────┬─────────┘         └────────┬─────────┘
         │                             │
         │  HTTPS API Calls            │
         └──────────┬──────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────────────────────┐
│              RAILWAY CLOUD PLATFORM                         │
│                                                             │
│  ┌────────────────────────────────────────────────────┐   │
│  │  Load Balancer                                     │   │
│  │  - SSL Termination                                 │   │
│  │  - DDoS Protection                                 │   │
│  │  - Request Routing                                 │   │
│  └────────────────┬───────────────────────────────────┘   │
│                   │                                        │
│                   ▼                                        │
│  ┌────────────────────────────────────────────────────┐   │
│  │  Node.js Container (Express Server)                │   │
│  │                                                     │   │
│  │  Environment: Production                           │   │
│  │  Port: Dynamic (Railway assigned)                  │   │
│  │  Memory: 512MB-1GB                                 │   │
│  │  Auto-restart: Enabled                             │   │
│  │  Health Check: /health endpoint                    │   │
│  │                                                     │   │
│  │  Routes:                                           │   │
│  │  - /api/shopify/products                          │   │
│  │  - /api/shopify/cart                              │   │
│  │  - /api/shopify/checkout                          │   │
│  │  - /api/shopify/lens-options                      │   │
│  │  - ... and more                                   │   │
│  └────────────────┬───────────────────────────────────┘   │
│                                                             │
│  ┌────────────────────────────────────────────────────┐   │
│  │  Logging & Monitoring                              │   │
│  │  - Request logs                                    │   │
│  │  - Error tracking                                  │   │
│  │  - Performance metrics                             │   │
│  └────────────────────────────────────────────────────┘   │
│                                                             │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │  GraphQL & REST API Calls
                     │
                     ▼
┌────────────────────────────────────────────────────────────┐
│                     SHOPIFY PLATFORM                        │
│                                                             │
│  ┌────────────────────────────────────────────────────┐   │
│  │  Storefront API (GraphQL)                          │   │
│  │  - Read products                                   │   │
│  │  - Read collections                                │   │
│  │  - Cart operations                                 │   │
│  │  - Checkout creation                               │   │
│  └────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌────────────────────────────────────────────────────┐   │
│  │  Admin API (REST)                                  │   │
│  │  - Product management                              │   │
│  │  - Order management                                │   │
│  │  - Inventory updates                               │   │
│  └────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌────────────────────────────────────────────────────┐   │
│  │  Database                                          │   │
│  │  - Products & Variants                             │   │
│  │  - Collections                                     │   │
│  │  - Customers                                       │   │
│  │  - Orders                                          │   │
│  │  - Cart Sessions                                   │   │
│  └────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌────────────────────────────────────────────────────┐   │
│  │  CDN (Content Delivery Network)                    │   │
│  │  - Product images                                  │   │
│  │  - Static assets                                   │   │
│  │  - Global distribution                             │   │
│  └────────────────────────────────────────────────────┘   │
│                                                             │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │  Checkout redirect
                     │
                     ▼
┌────────────────────────────────────────────────────────────┐
│                 PAYMENT GATEWAY (GoKwik)                    │
│                                                             │
│  - Payment processing                                      │
│  - UPI, Cards, Net Banking                                 │
│  - Indian market optimization                              │
│  - Payment confirmation                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘

Domains:
────────
- Backend API: motivated-intuition-production.up.railway.app
- Live Store: www.eyejack.in
- Admin Panel: eyejack.myshopify.com/admin
```

---

## Summary

This document provides comprehensive visual representations of:

1. **System Architecture** - How all components fit together
2. **Data Flow** - How information moves through the system
3. **User Journeys** - How users interact with the app
4. **Component Structure** - Detailed breakdown of code organization
5. **API Flow** - Complete request/response lifecycle
6. **State Management** - How app state is managed and synchronized
7. **Deployment** - How code gets from development to production

These diagrams complement the main analysis document and provide a visual reference for understanding the EyeJack project's architecture and implementation.

---

**Document Version:** 1.0  
**Last Updated:** November 13, 2025  
**Companion to:** EYEJACK_PROJECT_ANALYSIS.md

