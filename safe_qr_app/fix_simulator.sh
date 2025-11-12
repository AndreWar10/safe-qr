#!/bin/bash

# Script to fix iOS simulator destination issue
# This script clears caches and ensures the correct simulator is used

echo "🔧 Fixing iOS Simulator Destination Issue..."
echo ""

# Clear Xcode derived data (already done, but doing it again to be sure)
echo "📦 Clearing Xcode derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Shutdown the problematic iPhone 17 Pro Max simulator
echo "🛑 Shutting down iPhone 17 Pro Max (iOS 26.0)..."
xcrun simctl shutdown "B95B3B8A-3821-437D-A38D-BE6EDC346B3A" 2>/dev/null || true

# Boot iPhone 16 Pro (iOS 18.6) - a stable simulator
echo "🚀 Booting iPhone 16 Pro (iOS 18.6)..."
xcrun simctl boot "D55E9589-AF20-4E0E-AA8D-33F1E39CC0DE" 2>/dev/null || echo "   (Simulator may already be booted)"

echo ""
echo "✅ Done! Now you can:"
echo ""
echo "1. In VS Code/Android Studio: Select the device from the device dropdown"
echo "   - Look for 'iPhone 16 Pro' or device ID: D55E9589-AF20-4E0E-AA8D-33F1E39CC0DE"
echo ""
echo "2. Or run from terminal:"
echo "   flutter run -d D55E9589-AF20-4E0E-AA8D-33F1E39CC0DE"
echo ""
echo "3. Or list available devices:"
echo "   flutter devices"
echo ""

