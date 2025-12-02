# Facebook Sign-In - Quick Start 🚀

## ⚡ 5-Minute Setup

### Step 1: Create Facebook App (2 minutes)

1. Go to https://developers.facebook.com/
2. **My Apps** → **Create App**
3. Type: **Consumer** → **Next**
4. Fill in app name and email → **Create App**
5. Add **Facebook Login** product
6. Note your **App ID** and **App Secret**

### Step 2: Enable in Firebase (1 minute)

1. Go to https://console.firebase.google.com/
2. Select project: `rcbfinal-e7f13`
3. **Authentication** → **Sign-in method**
4. Enable **Facebook**
5. Add your **App ID** and **App Secret**
6. Copy the **OAuth redirect URI**

### Step 3: Configure Facebook App (1 minute)

1. Go back to Facebook Developers Console
2. **Facebook Login** → **Settings**
3. Add **Valid OAuth Redirect URIs**:
   ```
   https://rcbfinal-e7f13.firebaseapp.com/__/auth/handler
   ```
4. **Save Changes**

### Step 4: Install Package & Test (1 minute)

```bash
flutter pub get
flutter run
```

- Click the Facebook button on sign-in page
- Log in with Facebook
- You're signed in! ✓

## 📋 Platform Configuration

### Android Setup

1. Add to `android/app/src/main/res/values/strings.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">RoboCleanerBuddy</string>
    <string name="facebook_app_id">YOUR_APP_ID_HERE</string>
    <string name="fb_login_protocol_scheme">fbYOUR_APP_ID_HERE</string>
    <string name="facebook_client_token">YOUR_CLIENT_TOKEN</string>
</resources>
```

2. Add to `android/app/src/main/AndroidManifest.xml` (inside `<application>`):

```xml
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

3. In Facebook Developer Console → **Settings** → **Basic** → **Add Platform** → **Android**:
   - Package Name: `com.example.robocleaner`
   - Generate Key Hash:
     ```bash
     cd android
     keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
     ```
     Password: `android`

### iOS Setup

1. Add to `ios/Runner/Info.plist` (before `</dict>`):

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fbYOUR_APP_ID_HERE</string>
    </array>
  </dict>
</array>

<key>FacebookAppID</key>
<string>YOUR_APP_ID_HERE</string>

<key>FacebookClientToken</key>
<string>YOUR_CLIENT_TOKEN</string>

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

2. In Facebook Developer Console → **Settings** → **Basic** → **Add Platform** → **iOS**:
   - Bundle ID: `com.example.robocleaner`

### Web Setup

1. In Facebook Developer Console → **Settings** → **Basic** → **Add Platform** → **Website**:
   - Site URL: `https://rcbfinal-e7f13.web.app` (or your domain)

## ✅ What Works Now

- ✅ Facebook Sign-In button functional
- ✅ One-click authentication with Facebook
- ✅ Automatic account creation
- ✅ Profile picture fetching
- ✅ Email retrieval
- ✅ Remember Me support
- ✅ Auto-login
- ✅ Audit logging
- ✅ Role-based access (admin/user)

## 🧪 Test Checklist

- [ ] Click Facebook button
- [ ] Facebook login page appears
- [ ] Select Facebook account
- [ ] Grant permissions
- [ ] See loading indicator
- [ ] Redirected to dashboard
- [ ] Profile picture shows
- [ ] Check Firestore for user document
- [ ] Sign out works
- [ ] Sign in again works

## 🐛 Common Issues

### "App Not Setup" Error
→ Make Facebook app "Live" in Developer Console OR add test users

### "Invalid Key Hash" (Android)
→ Regenerate key hash and add to Facebook console

### No Email Returned
→ Some users don't have email on Facebook - handle null cases

### Facebook SDK Error (Android)
→ Check strings.xml has correct App ID (no spaces)

## 📞 Need Detailed Help?

See full guide: `FACEBOOK_SIGNIN_SETUP.md`

## 🎉 You're Ready!

Users can now sign in with Facebook in one tap! 🚀

Both Google and Facebook authentication are now fully functional! 🎊

