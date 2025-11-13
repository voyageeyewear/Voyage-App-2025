image.png# 📢 Announcement Bar - Quick Guide

## 🎯 **What is it?**

A beautiful banner at the top of your app that displays important messages to users.

---

## 🎨 **Visual Preview:**

```
┌─────────────────────────────────────────────┐
│ Voyage Eyewear        🔍     🛒             │  ← App Header
├─────────────────────────────────────────────┤
│                                             │
│  🎉  Free Shipping on Orders Above ₹999!   │  ← ANNOUNCEMENT BAR
│                   ● ○ ○                     │     (Auto-scrolls)
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│        Welcome to Voyage Eyewear            │
│                                             │
│  [Product Grid Below]                       │
│                                             │
└─────────────────────────────────────────────┘
```

---

## ✨ **Features:**

✅ **Auto-Scrolling** - Messages change every 4 seconds  
✅ **3 Messages** - Rotates between offers/announcements  
✅ **Icons** - Visual indicators for each message  
✅ **Dots** - Shows which message is current  
✅ **Swipeable** - Users can swipe to next message  
✅ **Responsive** - Adapts to all screen sizes  

---

## ⚙️ **How to Change Messages:**

### **Step 1: Open Config File**

File: `voyage_flutter_app/lib/config/announcement_config.dart`

### **Step 2: Edit Messages**

```dart
static const List<AnnouncementMessage> messages = [
  AnnouncementMessage(
    text: '🎉 Your message here!',
    icon: Icons.local_shipping_outlined,
  ),
  // Add more...
];
```

### **Step 3: Rebuild APK**

```bash
cd /Users/dhruv/Desktop/Voyage-app-2025
bash UPDATE_APK.sh
```

---

## 🎨 **Icon Options:**

| Icon Code | Symbol | Use Case |
|-----------|--------|----------|
| `Icons.local_shipping_outlined` | 🚚 | Free shipping |
| `Icons.new_releases_outlined` | ✨ | New collection |
| `Icons.discount_outlined` | 💎 | Discounts/Sales |
| `Icons.flash_on_outlined` | ⚡ | Flash sale |
| `Icons.card_giftcard_outlined` | 🎁 | Gift/Rewards |
| `Icons.schedule_outlined` | ⏰ | Limited time |
| `Icons.celebration_outlined` | 🎉 | Special events |
| `Icons.local_offer_outlined` | 🏷️ | Offers |

---

## 🔧 **Common Customizations:**

### **Change Scroll Speed:**
```dart
static const Duration scrollDuration = Duration(seconds: 3); // Faster
static const Duration scrollDuration = Duration(seconds: 6); // Slower
```

### **Disable Auto-Scroll:**
```dart
static const bool autoScroll = false; // Manual swipe only
```

### **Change Height:**
```dart
static const double barHeight = 50.0; // Taller
static const double barHeight = 40.0; // Shorter
```

### **Disable Completely:**
```dart
static const bool enabled = false; // Hides announcement bar
```

---

## 💡 **Message Ideas:**

### **Shipping:**
- 🚚 Free Shipping on Orders Above ₹999!
- 📦 Express Delivery in 2-3 Days
- 🌍 Nationwide Delivery Available

### **Offers:**
- 💎 Up to 70% Off on Selected Items
- 🎁 Buy 2 Get 1 Free - Limited Time!
- 🏷️ Use Code VOYAGE10 for Extra 10% Off

### **New Collection:**
- ✨ New Arrivals - Check Out Now!
- 🚀 Fresh Collection Just Dropped
- 🌟 Exclusive Designer Frames

### **Events:**
- 🪔 Diwali Special - Extra 20% Off
- 🎆 New Year Sale Live Now!
- 💝 Valentine's Day Special Offers

---

## 📱 **Installation:**

1. **APK is ready on your Desktop:**
   - File: `Voyage-Eyewear.apk`
   - Size: 52MB

2. **Install on your phone:**
   ```bash
   adb install -r /Users/dhruv/Desktop/Voyage-Eyewear.apk
   ```
   OR copy to phone and install manually

3. **Open app and see the announcement bar at top!**

---

## ✅ **Files to Know:**

| File | Purpose |
|------|---------|
| `lib/config/announcement_config.dart` | **Edit messages here** |
| `lib/widgets/announcement_bar.dart` | Widget code (don't edit) |
| `lib/screens/home_screen.dart` | Where it's displayed |

---

## 🎯 **Quick Start:**

1. ✅ Install new APK
2. ✅ See announcement bar at top
3. ✅ Watch messages auto-scroll
4. ✅ Edit `announcement_config.dart` to customize
5. ✅ Rebuild when ready!

---

**Your app now looks professional like Shopify stores!** 🎉

