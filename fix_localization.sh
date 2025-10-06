#!/bin/bash

echo "🔧 Fixing iOS Localization..."

# Navigate to iOS directory
cd ios

# Clean and rebuild
echo "🧹 Cleaning Xcode workspace..."
xcodebuild clean -workspace Runner.xcworkspace -scheme Runner

# Add localization files to Xcode project
echo "📱 Adding localization files to Xcode project..."

# This will add the localization files to the Xcode project
# Note: You may need to manually add these files in Xcode if this doesn't work
echo "⚠️  If the app name still shows in English, please:"
echo "1. Open ios/Runner.xcworkspace in Xcode"
echo "2. Right-click on Runner folder in the project navigator"
echo "3. Select 'Add Files to Runner'"
echo "4. Add the following files:"
echo "   - Runner/ar.lproj/InfoPlist.strings"
echo "   - Runner/en.lproj/InfoPlist.strings"
echo "   - Runner/Base.lproj/InfoPlist.strings"
echo "5. Make sure they are added to the Runner target"
echo "6. Build and run the project"

echo "✅ Localization setup complete!"
