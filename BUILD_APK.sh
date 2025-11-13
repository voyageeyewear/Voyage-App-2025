#!/bin/bash

echo "======================================"
echo "🚀 Building Voyage Eyewear APK"
echo "======================================"
echo ""

# Navigate to Flutter app directory
cd /Users/dhruv/Desktop/Voyage-app-2025/voyage_flutter_app

echo "📦 Step 1: Cleaning previous builds..."
flutter clean

echo ""
echo "📥 Step 2: Getting dependencies..."
flutter pub get

echo ""
echo "🔨 Step 3: Building release APK..."
echo "⏳ This will take 5-10 minutes. Please wait..."
echo ""

flutter build apk --release

echo ""
echo "======================================"
echo "✅ BUILD COMPLETE!"
echo "======================================"
echo ""

# Copy APK to Desktop with consistent name
APK_PATH="/Users/dhruv/Desktop/Voyage-app-2025/voyage_flutter_app/build/app/outputs/flutter-apk/app-release.apk"
DESKTOP_APK="/Users/dhruv/Desktop/Voyage-Eyewear.apk"

echo "📦 Copying APK to Desktop..."
cp "$APK_PATH" "$DESKTOP_APK"

echo ""
echo "✅ APK updated on Desktop!"
echo "📱 Location: $DESKTOP_APK"
echo "📦 Size: $(du -h "$DESKTOP_APK" | cut -f1)"
echo "📅 Built: $(date '+%B %d, %Y at %I:%M %p')"
echo ""
echo "🎉 Opening Desktop folder..."

# Open Desktop
open /Users/dhruv/Desktop/

echo ""
echo "✨ Done! Your Voyage Eyewear APK is ready to install!"

