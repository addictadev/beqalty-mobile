# Deep Link Testing Guide for Baqalty

## Problem
When opening shared cart links like `https://baqalty-back.addictaco.website/api/v1/cart?shared_cart_id=43` from Google Chrome, it shows "unauthorized 401" error because the API requires authentication.

## Solution
We've created a redirect page that handles the deep linking properly without requiring authentication.

## Files Created

### 1. `shared-cart-redirect.html`
- Main redirect page that handles shared cart deep links
- Extracts `shared_cart_id` from URL parameters
- Tries to open the app using Universal Links and Custom Schemes
- Falls back to app store if app is not installed

### 2. `test-deep-link.html`
- Test page with multiple deep link examples
- Useful for testing different scenarios

### 3. Updated `apple-app-site-association`
- Added support for API endpoints and redirect pages
- Enables Universal Links for shared cart functionality

## How to Test

### Method 1: Direct API Link (Will show 401 error)
```
https://baqalty-back.addictaco.website/api/v1/cart?shared_cart_id=43
```
❌ This will show 401 error because it requires authentication

### Method 2: Using Redirect Page (Recommended)
```
https://baqalty-back.addictaco.website/shared-cart-redirect.html?shared_cart_id=43
```
✅ This will work properly and open the app

### Method 3: Direct App Scheme
```
baqalty://shared-cart?id=43
```
✅ This will work if the app is installed

## Testing Steps

1. **Install the Baqalty app** on your device
2. **Open the test page**: `https://baqalty-back.addictaco.website/test-deep-link.html`
3. **Click on any test link** to verify deep linking works
4. **Test different scenarios**:
   - App installed: Should open the app
   - App not installed: Should redirect to app store
   - Invalid cart ID: Should show appropriate error

## Expected Behavior

### When App is Installed:
1. Click the shared cart link
2. Redirect page loads briefly
3. App opens automatically
4. App navigates to shared cart screen

### When App is Not Installed:
1. Click the shared cart link
2. Redirect page loads
3. After timeout, redirects to appropriate app store
4. User can download and install the app

## Server Configuration Required

To make this work, you need to:

1. **Upload the HTML files** to your server:
   - `shared-cart-redirect.html`
   - `test-deep-link.html`

2. **Update your server** to serve these files at:
   - `https://baqalty-back.addictaco.website/shared-cart-redirect.html`
   - `https://baqalty-back.addictaco.website/test-deep-link.html`

3. **Update the `apple-app-site-association`** file on your server to include the new paths

4. **Update the `assetlinks.json`** file on your server (if needed)

## App Configuration

Make sure your Flutter app is configured to handle the deep links:

### Android (android/app/src/main/AndroidManifest.xml)
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="baqalty" />
</intent-filter>
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https"
          android:host="baqalty-back.addictaco.website" />
</intent-filter>
```

### iOS (ios/Runner/Info.plist)
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>baqalty.deeplink</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>baqalty</string>
        </array>
    </dict>
</array>
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:baqalty-back.addictaco.website</string>
</array>
```

## Testing URLs

Use these URLs for testing:

1. **Test Page**: `https://baqalty-back.addictaco.website/test-deep-link.html`
2. **Shared Cart 43**: `https://baqalty-back.addictaco.website/shared-cart-redirect.html?shared_cart_id=43`
3. **Shared Cart 123**: `https://baqalty-back.addictaco.website/shared-cart-redirect.html?shared_cart_id=123`

## Troubleshooting

### If deep links don't work:
1. Check if the app is properly installed
2. Verify the URL scheme in the app configuration
3. Test with the direct scheme first: `baqalty://shared-cart?id=43`
4. Check server logs for any errors

### If Universal Links don't work:
1. Verify the `apple-app-site-association` file is accessible
2. Check that the file is served with correct content-type
3. Test the association file: `https://baqalty-back.addictaco.website/.well-known/apple-app-site-association`

### If redirect page doesn't work:
1. Check if the HTML file is accessible
2. Verify the JavaScript console for errors
3. Test with different browsers
