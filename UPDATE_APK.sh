#!/bin/bash

echo "======================================"
echo "🔄 Updating Voyage Eyewear APK"
echo "======================================"
echo ""

cd /Users/dhruv/Desktop/Voyage-app-2025/voyage_flutter_app

echo "🔨 Building new APK..."
flutter build apk --release

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    
    # Copy to Desktop
    APK_PATH="/Users/dhruv/Desktop/Voyage-app-2025/voyage_flutter_app/build/app/outputs/flutter-apk/app-release.apk"
    DESKTOP_APK="/Users/dhruv/Desktop/Voyage-Eyewear.apk"
    
    cp "$APK_PATH" "$DESKTOP_APK"
    
    echo ""
    echo "======================================"
    echo "✅ APK UPDATED ON DESKTOP!"
    echo "======================================"
    echo ""
    echo "📱 Location: Voyage-Eyewear.apk"
    echo "📦 Size: $(du -h "$DESKTOP_APK" | cut -f1)"
    echo "📅 Updated: $(date '+%B %d, %Y at %I:%M %p')"
    echo ""
    echo "🚀 Ready to install on your phone!"
    
    # Open Desktop
    open /Users/dhruv/Desktop/
else
    echo ""
    echo "❌ Build failed! Please check the errors above."
    exit 1
fi

