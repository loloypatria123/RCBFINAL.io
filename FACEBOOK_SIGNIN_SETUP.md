# Facebook Sign-In Setup Guide 🚀

Complete guide to enable Facebook authentication in your Flutter app using Firebase.

## 📋 Prerequisites

- Firebase project set up (`rcbfinal-e7f13`)
- Facebook Developer Account
- Flutter app with Firebase configured

## 🎯 Quick Overview

This guide covers:
1. Creating a Facebook App
2. Configuring Firebase
3. Setting up Android
4. Setting up iOS
5. Setting up Web
6. Testing

---

## Part 1: Create Facebook App (15 minutes)

### Step 1: Go to Facebook Developers

1. Visit https://developers.facebook.com/
2. Click **"Get Started"** (if you don't have an account)
3. Complete the registration/verification process
4. Once logged in, click **"My Apps"** → **"Create App"**

### Step 2: Create Facebook App

1. Select app type: **"Consumer"** or **"None"** (for authentication)
2. Click **"Next"**
3. Fill in app details:
   - **App Name**: `RoboCleanerBuddy` (or your preferred name)
   - **App Contact Email**: Your email
   - **Business Account**: (optional, can skip)
4. Click **"Create App"**
5. Complete security check (CAPTCHA)

### Step 3: Add Facebook Login Product

1. In your app dashboard, find **"Add Products to Your App"**
2. Locate **"Facebook Login"** card
3. Click **"Set Up"**
4. Choose **"Quickstart"**
5. Select platforms you want to support:
   - ✅ Android
   - ✅ iOS  
   - ✅ Web

### Step 4: Get App ID and App Secret

1. In left sidebar, click **"Settings"** → **"Basic"**
2. Note down:
   - **App ID**: `XXXXXXXXXXXX` (you'll need this)
   - **App Secret**: Click **"Show"** → Copy (you'll need this)
3. Keep this page open for next steps

---

## Part 2: Configure Firebase (5 minutes)

### Step 1: Enable Facebook Sign-In in Firebase

1. Go to https://console.firebase.google.com/
2. Select project: **`rcbfinal-e7f13`**
3. Click **"Authentication"** in left sidebar
4. Click **"Sign-in method"** tab
5. Find **"Facebook"** in the list
6. Click on **"Facebook"** row
7. Toggle **"Enable"** to ON

### Step 2: Configure Facebook Provider

**Important:** After toggling "Enable" to ON in Step 1, a configuration form will appear.

1. **Locate the App ID field:**
   - You'll see a text box labeled **"App ID"**
   - Go to your Facebook Developer Console (the tab you kept open from Part 1, Step 4)
   - Copy your **Facebook App ID** (it's a long number like `1234567890123456`)
   - Return to Firebase Console
   - Paste the App ID into the **"App ID"** field

2. **Locate the App Secret field:**
   - Below the App ID, you'll see a text box labeled **"App secret"**
   - Go back to Facebook Developer Console
   - In **Settings** → **Basic**, find **"App Secret"**
   - Click the **"Show"** button next to it
   - You may need to re-enter your Facebook password for security
   - Copy the App Secret (it's an alphanumeric string like `a1b2c3d4e5f6g7h8i9j0`)
   - Return to Firebase Console
   - Paste the App Secret into the **"App secret"** field

3. **Copy the OAuth Redirect URI:**
   - Below the App Secret field, you'll see a read-only text box labeled **"OAuth redirect URI"**
   - It will show something like:
     ```
     https://rcbfinal-e7f13.firebaseapp.com/__/auth/handler
     ```
   - Click on the URI or the copy button next to it to copy it
   - **IMPORTANT:** Keep this URI copied - you'll need it in the next step
   - You can also write it down or keep this tab open

4. **Save the configuration:**
   - After entering both App ID and App Secret
   - Click the **"Save"** button at the bottom of the form
   - You should see a success message or the form will close
   - Facebook should now appear as "Enabled" in your sign-in methods list

**What it should look like:**
```
☑ Facebook                           [Enabled]
  App ID:        1234567890123456
  App secret:    ********************* (hidden)
  OAuth URI:     https://rcbfinal-e7f13.firebaseapp.com/__/auth/handler
                                     [Save]  [Cancel]
```

**Troubleshooting:**
- If you don't see the configuration form, make sure you toggled "Enable" to ON
- If "Save" button is grayed out, ensure both App ID and App Secret are filled in
- If you get an error, double-check that you copied the correct values from Facebook
- Make sure there are no extra spaces before or after the App ID and App Secret

### Step 3: Add OAuth Redirect URI to Facebook App

1. Go back to Facebook Developers Console
2. Go to **"Facebook Login"** → **"Settings"**
3. Find **"Valid OAuth Redirect URIs"**
4. Paste the redirect URI from Firebase:
   ```
   https://rcbfinal-e7f13.firebaseapp.com/__/auth/handler
   ```
5. Click **"Save Changes"**

---

## Part 3: Android Setup (10 minutes)

### Step 1: Add Android to Facebook App

1. In Facebook Developers Console
2. Go to **"Settings"** → **"Basic"**
3. Scroll to bottom → Click **"+ Add Platform"**
4. Select **"Android"**

### Step 2: Configure Android Platform

Fill in the following:

1. **Package Name**: 
   
   **How to find your package name:**
   
   a. Open your project in your code editor
   
   b. Navigate to one of these files:
      - `android/app/build.gradle.kts` (Kotlin DSL - newer Flutter projects)
      - OR `android/app/build.gradle` (Groovy - older Flutter projects)
   
   c. Look for the `applicationId` line:
      - In `build.gradle.kts` (Kotlin), look for:
        ```kotlin
        applicationId = "com.example.robocleaner"
        ```
        (Around line 27 in the `defaultConfig` section)
      
      - In `build.gradle` (Groovy), look for:
        ```groovy
        applicationId "com.example.robocleaner"
        ```
        (In the `defaultConfig` block)
   
   d. Copy the value inside the quotes
   
   **Your package name is:**
   ```
   com.example.robocleaner
   ```
   
   **Visual guide - what to look for:**
   ```kotlin
   android {
       namespace = "com.example.robocleaner"
       ...
       defaultConfig {
           applicationId = "com.example.robocleaner"  ← THIS IS YOUR PACKAGE NAME
           minSdk = ...
           targetSdk = ...
       }
   }
   ```
   
   e. Paste this into the **"Package Name"** field in Facebook Developer Console
   
   **Quick way to find it:**
   - Press `Ctrl+P` (Windows/Linux) or `Cmd+P` (Mac) in your editor
   - Type: `build.gradle.kts`
   - Press Enter
   - Press `Ctrl+F` (Windows/Linux) or `Cmd+F` (Mac)
   - Search for: `applicationId`
   - Copy the value in quotes

2. **Class Name** (optional):
   
   **How to construct your class name:**
   
   The class name follows this pattern:
   ```
   {your_package_name}.MainActivity
   ```
   
   Since your package name is `com.example.robocleaner`, your class name is:
   ```
   com.example.robocleaner.MainActivity
   ```
   
   **Note:** This field is optional for Facebook configuration. You can leave it blank or fill it in.

n3. **Key Hashes**: Generate the Facebook key hash
   
   **For Debug (Development/Testing):**
   
   The key hash is needed for Facebook to verify your app. Follow these steps:

   ---

   ### 🪟 **Method 1: Windows Command Prompt (Recommended)**
   
   **Step 1: Check if you have the required tools**
   
   Open Command Prompt and check:
   ```cmd
   keytool
   ```
   - If you see keytool options, ✅ keytool is installed
   - If you get "not recognized", keytool is not in PATH (see troubleshooting below)
   
   ```cmd
   openssl version
   ```
   - If you see OpenSSL version, ✅ openssl is installed
   - If you get "not recognized", you need to install OpenSSL (see troubleshooting below)
   
   **Step 2: Generate the key hash**
   
   **Option A: If you have OpenSSL installed:**
   
   1. Open **Command Prompt** (not PowerShell)
   2. Navigate to your project:
      ```cmd
      cd C:\Users\ASUS\robocleaner\android
      ```
   3. Run this command (all in one line):
      ```cmd
      keytool -exportcert -alias androiddebugkey -keystore "%USERPROFILE%\.android\debug.keystore" | openssl sha1 -binary | openssl base64
      ```
   4. When prompted for password, type: `android` (press Enter)
   5. You'll get output like: `Ab1Cd2Ef3Gh4Ij5Kl6Mn7Op8Qr9St0=`
   6. **Copy this hash** - this is your Facebook Key Hash!
   
   **Option B: If you DON'T have OpenSSL (Easiest Method):**
   
   1. Open **Command Prompt**
   2. Navigate to your project:
      ```cmd
      cd C:\Users\ASUS\robocleaner\android
      ```
   3. Run this command:
      ```cmd
      gradlew signingReport
      ```
   4. Wait for the build to complete
   5. Look for output like this:
      ```
      Variant: debug
      Config: debug
      Store: C:\Users\ASUS\.android\debug.keystore
      Alias: androiddebugkey
      MD5: XX:XX:XX:...
      SHA1: A1:B2:C3:D4:E5:F6:G7:H8:I9:J0:K1:L2:M3:N4:O5:P6:Q7:R8:S9:T0
      SHA-256: ...
      Valid until: ...
      ```
   6. Copy the **SHA1** value (e.g., `A1:B2:C3:D4:E5:F6:G7:H8:I9:J0:K1:L2:M3:N4:O5:P6:Q7:R8:S9:T0`)
   7. Go to this online converter: https://tomeko.net/online_tools/hex_to_base64.php
   8. Remove the colons from SHA1: `A1B2C3D4E5F6G7H8I9J0K1L2M3N4O5P6Q7R8S9T0`
   9. Convert to Base64 and copy the result
   10. This is your Facebook Key Hash!
   
   **Option C: Use PowerShell (if Command Prompt doesn't work):**
   
   1. Open **PowerShell**
   2. Navigate to your project:
      ```powershell
      cd C:\Users\ASUS\robocleaner\android
      ```
   3. Run:
      ```powershell
      keytool -exportcert -alias androiddebugkey -keystore "$env:USERPROFILE\.android\debug.keystore" | openssl sha1 -binary | openssl base64
      ```
   4. Password: `android`

   ---

   ### 🍎 **Method 2: Mac/Linux**
   
   ```bash
   cd android
   keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
   ```
   Password: `android`

   ---

   ### 🔧 **Troubleshooting**

   **Problem: "keytool is not recognized"**
   
   Solution 1: Add Java to PATH
   ```cmd
   set PATH=%PATH%;C:\Program Files\Android\Android Studio\jbr\bin
   ```
   Then try the keytool command again.
   
   Solution 2: Use full path to keytool
   ```cmd
   "C:\Program Files\Android\Android Studio\jbr\bin\keytool" -exportcert -alias androiddebugkey -keystore "%USERPROFILE%\.android\debug.keystore" | openssl sha1 -binary | openssl base64
   ```

   **Problem: "openssl is not recognized"**
   
   Solution: Use **Option B** (gradlew signingReport) above - no OpenSSL needed!
   
   Alternative: Install OpenSSL
   1. Download from: https://slproweb.com/products/Win32OpenSSL.html
   2. Install "Win64 OpenSSL v3.x.x Light"
   3. Add to PATH: `C:\Program Files\OpenSSL-Win64\bin`
   4. Restart Command Prompt and try again

   **Problem: "Keystore was tampered with, or password was incorrect"**
   
   Solution: Make sure you're typing the password exactly: `android` (lowercase, no spaces)

   **Problem: "Keystore file does not exist"**
   
   Solution: Run your app once in debug mode to create the debug keystore:
   ```cmd
   flutter run
   ```
   Then try generating the key hash again.

   ---

   ### ✅ **After Getting Your Key Hash**

   1. Copy the key hash (looks like: `Ab1Cd2Ef3Gh4Ij5Kl6Mn7Op8Qr9St0=`)
   2. Go to Facebook Developer Console
   3. Find the **"Key Hashes"** field
   4. Paste your key hash
   5. Click **"Save Changes"**

   ---

   ### 📝 **For Release (when publishing to Play Store):**
   
   When you're ready to publish your app, you'll need to generate a release key hash:
   
   ```cmd
   keytool -exportcert -alias your-release-key-alias -keystore path\to\your\release-key.jks | openssl sha1 -binary | openssl base64
   ```
   - Replace `your-release-key-alias` with your actual release key alias
   - Replace `path\to\your\release-key.jks` with your actual keystore file path
   - Enter your release keystore password when prompted
   
   **Note:** For now, just add the debug key hash. You can add the release key hash later.

4. **Single Sign On**: Enable this (toggle ON)

5. Click **"Save Changes"**

### Step 3: Update AndroidManifest.xml

1. Open `android/app/src/main/AndroidManifest.xml`
2. Add the following inside `<application>` tag (before `</application>`):

```xml
<!-- Facebook Configuration -->
<meta-data
    android:name="com.facebook.sdk.ApplicationId"
    android:value="@string/facebook_app_id"/>
    
<meta-data
    android:name="com.facebook.sdk.ClientToken"
    android:value="@string/facebook_client_token"/>

<activity
    android:name="com.facebook.FacebookActivity"
    android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"
    android:label="@string/app_name" />
    
<activity
    android:name="com.facebook.CustomTabActivity"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="@string/fb_login_protocol_scheme" />
    </intent-filter>
</activity>
```

3. Add internet permission (if not already present):

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### Step 4: Create strings.xml

1. Create/Edit `android/app/src/main/res/values/strings.xml`
2. Add the following (replace with your actual Facebook App ID):

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">RoboCleanerBuddy</string>
    <string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
    <string name="fb_login_protocol_scheme">fbYOUR_FACEBOOK_APP_ID</string>
    <string name="facebook_client_token">YOUR_FACEBOOK_CLIENT_TOKEN</string>
</resources>
```

Example:
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">RoboCleanerBuddy</string>
    <string name="facebook_app_id">123456789012345</string>
    <string name="fb_login_protocol_scheme">fb123456789012345</string>
    <string name="facebook_client_token">abc123def456ghi789</string>
</resources>
```

**Where to find Client Token:**
- Go to Facebook Developer Console
- **Settings** → **Advanced**
- Scroll to **"Security"** section
- Find **"Client Token"**

---

## Part 4: iOS Setup (10 minutes)

### Step 1: Add iOS to Facebook App

1. In Facebook Developers Console
2. Go to **"Settings"** → **"Basic"**
3. Click **"+ Add Platform"**
4. Select **"iOS"**

### Step 2: Configure iOS Platform

Fill in the following:

1. **Bundle ID**: 
   ```
   com.example.robocleaner
   ```
   (Get this from `ios/Runner.xcodeproj` → check Bundle Identifier)

2. **Single Sign On**: Enable this (toggle ON)

3. Click **"Save Changes"**

### Step 3: Update Info.plist

1. Open `ios/Runner/Info.plist`
2. Add the following before `</dict>`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fbYOUR_FACEBOOK_APP_ID</string>
    </array>
  </dict>
</array>

<key>FacebookAppID</key>
<string>YOUR_FACEBOOK_APP_ID</string>

<key>FacebookClientToken</key>
<string>YOUR_FACEBOOK_CLIENT_TOKEN</string>

<key>FacebookDisplayName</key>
<string>RoboCleanerBuddy</string>

<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbapi</string>
  <string>fb-messenger-share-api</string>
  <string>fbauth2</string>
  <string>fbshareextension</string>
</array>
```

Example:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fb123456789012345</string>
    </array>
  </dict>
</array>

<key>FacebookAppID</key>
<string>123456789012345</string>

<key>FacebookClientToken</key>
<string>abc123def456ghi789</string>

<key>FacebookDisplayName</key>
<string>RoboCleanerBuddy</string>
```

---

## Part 5: Web Setup (5 minutes)

### Step 1: Add Web to Facebook App

1. In Facebook Developers Console
2. Go to **"Settings"** → **"Basic"**
3. Click **"+ Add Platform"**
4. Select **"Website"**

### Step 2: Configure Website Platform

1. **Site URL**: Enter your website URL
   - For local testing: `http://localhost:5000` or `http://localhost:8080`
   - For production: `https://yourdomain.com`
   - For Firebase Hosting: `https://rcbfinal-e7f13.web.app`

2. Click **"Save Changes"**

### Step 3: Make App Public (Important!)

1. In Facebook Developers Console
2. Top of the page, you'll see a toggle/button
3. Change app status from **"Development"** to **"Live"**
4. Follow the prompts to make your app public
   - You may need to provide Privacy Policy URL
   - Accept Facebook Platform Terms

**Note**: For testing, you can keep it in Development mode and add test users.

---

## Part 6: Testing (10 minutes)

### Step 1: Install Dependencies

```bash
flutter pub get
```

### Step 2: Run the App

**For Android:**
```bash
flutter run -d android
```

**For iOS:**
```bash
flutter run -d ios
```

**For Web:**
```bash
flutter run -d chrome
```

### Step 3: Test Facebook Sign-In

1. Launch the app
2. Go to Sign-In page
3. Click the **"Facebook"** button
4. Facebook login dialog should appear
5. Log in with your Facebook account
6. Grant permissions (email, public_profile)
7. You should be redirected to the app
8. Check if you're successfully signed in!

### Step 4: Verify in Firebase Console

1. Go to Firebase Console → Authentication → Users
2. You should see your new user with Facebook provider
3. Check Firestore → `users` collection
4. Verify user document was created with correct data

### Step 5: Check Audit Logs

1. Go to Firestore → `audit_logs` collection
2. Look for recent Facebook sign-in logs
3. Verify successful login was recorded

---

## 🧪 Test Checklist

- [ ] Facebook button appears on sign-in page
- [ ] Clicking Facebook button opens Facebook login
- [ ] Can select Facebook account
- [ ] Can grant permissions
- [ ] Successfully redirected back to app
- [ ] User appears in Firebase Authentication
- [ ] User document created in Firestore
- [ ] Profile picture loads (if available)
- [ ] Display name shows correctly
- [ ] Email is captured
- [ ] Can sign out
- [ ] Can sign in again
- [ ] Remember Me works
- [ ] Audit log created

---

## 🐛 Troubleshooting

### Issue: "App Not Setup" Error

**Solution:**
- Make sure Facebook app is in "Live" mode, not "Development"
- OR add your test account as a Test User in Facebook Developer Console

### Issue: "Invalid Key Hash" (Android)

**Solution:**
- Regenerate the key hash and add it to Facebook console
- Make sure you're using the correct keystore (debug vs release)

### Issue: "Can't Load URL" (iOS)

**Solution:**
- Verify Bundle ID matches exactly
- Check Info.plist has correct Facebook App ID
- Verify URL schemes are set correctly

### Issue: No Email Returned

**Solution:**
- Request email permission explicitly
- Some Facebook accounts don't have email verified
- Handle cases where email might be null

### Issue: "The Facebook SDK requires a valid Facebook App ID"

**Solution:**
- Check strings.xml (Android) or Info.plist (iOS)
- Verify App ID is correct (no spaces)
- Rebuild the app after changes

### Issue: Facebook Login Works but Firebase Sign-In Fails

**Solution:**
- Check Firebase Console → Authentication → Facebook is enabled
- Verify App Secret is correct in Firebase
- Check OAuth redirect URI is added to Facebook app

---

## 📱 Platform-Specific Notes

### Android

- **Debug vs Release**: Different key hashes for debug and release builds
- **ProGuard**: If using ProGuard, add Facebook rules
- **Minimum SDK**: Requires minimum SDK 21 (Android 5.0)

### iOS

- **CocoaPods**: Run `cd ios && pod install` after adding the package
- **Xcode**: Open `.xcworkspace`, not `.xcodeproj`
- **Simulator**: Facebook login might not work on simulator for some iOS versions

### Web

- **HTTPS Required**: Facebook requires HTTPS in production
- **Localhost**: Works with http://localhost for development
- **Firebase Hosting**: Automatically has HTTPS

---

## 🔒 Security Best Practices

### 1. Protect App Secret

- Never commit App Secret to version control
- Use environment variables in production
- Regenerate if accidentally exposed

### 2. Validate Permissions

- Only request necessary permissions
- Review Facebook's data use policies
- Update privacy policy accordingly

### 3. Handle Denied Permissions

- App should work if user denies optional permissions
- Provide alternative authentication methods

### 4. User Data Privacy

- Follow GDPR/data protection laws
- Provide clear privacy policy
- Allow users to delete their data

---

## 📚 Additional Resources

- [Facebook Login Documentation](https://developers.facebook.com/docs/facebook-login/)
- [flutter_facebook_auth Package](https://pub.dev/packages/flutter_facebook_auth)
- [Firebase Facebook Auth](https://firebase.google.com/docs/auth/flutter/federated-auth#facebook)
- [Facebook App Review](https://developers.facebook.com/docs/app-review)

---

## 🎉 Success!

If you've completed all steps:

✅ Facebook Sign-In is fully functional!  
✅ Users can authenticate with one tap  
✅ User data is properly stored  
✅ Everything is logged for audit  

Your app now supports both **Google** and **Facebook** sign-in! 🚀

---

## 📞 Need Help?

If you encounter issues:

1. Check the troubleshooting section above
2. Review Facebook Developer Console logs
3. Check Flutter console for error messages
4. Verify all configuration files
5. Test on different devices/platforms

**Common Configuration Files to Check:**
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/res/values/strings.xml`
- `ios/Runner/Info.plist`
- Firebase Console settings
- Facebook Developer Console settings

Good luck! 🎊

