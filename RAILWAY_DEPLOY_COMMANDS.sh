#!/bin/bash

# ============================================
# Railway Deployment Script
# ============================================
# This script will deploy your backend to Railway
# making your app work on ANY network!
# ============================================

echo "=========================================="
echo "🚀 Deploying Voyage Backend to Railway"
echo "=========================================="
echo ""

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null
then
    echo "📦 Installing Railway CLI..."
    npm install -g @railway/cli
    echo "✅ Railway CLI installed!"
    echo ""
fi

# Navigate to backend directory
cd "$(dirname "$0")/voyage_backend"

echo "📍 Current directory: $(pwd)"
echo ""

# Login to Railway
echo "🔐 Logging in to Railway..."
echo "   (This will open your browser)"
railway login

echo ""
echo "✅ Logged in to Railway!"
echo ""

# Initialize Railway project
echo "🎯 Initializing Railway project..."
railway init

echo ""
echo "✅ Railway project created!"
echo ""

# Deploy the backend
echo "🚀 Deploying backend..."
railway up

echo ""
echo "✅ Backend deployed!"
echo ""

# Set environment variables
echo "⚙️  Setting environment variables..."
railway variables set SHOPIFY_STORE_DOMAIN=your-store.myshopify.com
railway variables set SHOPIFY_API_KEY=your-api-key
railway variables set SHOPIFY_ADMIN_ACCESS_TOKEN=your-access-token
railway variables set SHOPIFY_API_VERSION=2024-07

echo ""
echo "✅ Environment variables set!"
echo ""

# Get the public URL
echo "🌐 Getting your public URL..."
railway domain

echo ""
echo "=========================================="
echo "✅ DEPLOYMENT COMPLETE!"
echo "=========================================="
echo ""
echo "📝 Next Steps:"
echo ""
echo "1. Copy the URL shown above"
echo "   Example: https://voyage-backend-production.up.railway.app"
echo ""
echo "2. Update Flutter app:"
echo "   File: voyage_flutter_app/lib/utils/constants.dart"
echo ""
echo "   Change:"
echo "   static const String apiBaseUrl = 'http://192.168.31.183:3000';"
echo ""
echo "   To:"
echo "   static const String apiBaseUrl = 'YOUR_RAILWAY_URL';"
echo ""
echo "3. Rebuild APK:"
echo "   bash UPDATE_APK.sh"
echo ""
echo "4. Your app will now work EVERYWHERE! 🎉"
echo ""
echo "=========================================="

