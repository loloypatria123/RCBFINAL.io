# Fix Google Sign-In Web Error - Step by Step

## The Error You're Seeing:
```
ClientID not set. Either set it on a <meta name="google-signin-client_id" 
content="CLIENT_ID" /> tag, or pass clientId when initializing GoogleSignIn
```

## Why This Happens:
Google Sign-In on **web** needs an OAuth Client ID to be configured. This is different from Android/iOS which use Firebase configuration files.

## Solution: 2 Options

### Option A: Quick Fix - Add Client ID to index.html (Recommended)

1. **Get your Client ID** (see GET_GOOGLE_CLIENT_ID.md)

2. **Add to web/index.html:**
   ```html
   <head>
     <meta name="google-signin-client_id" content="YOUR_CLIENT_ID_HERE.apps.googleusercontent.com">
   </head>
   ```

3. **Restart your app:**
   ```bash
   # Stop current app (Ctrl+C)
   flutter run -d chrome
   ```

### Option B: Pass Client ID in Code

Modify `lib/services/google_signin_service.dart`:

```dart
static final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
  clientId: 'YOUR_CLIENT_ID_HERE.apps.googleusercontent.com', // Add this
);
```

## Step-by-Step: Get Client ID Now

### Using Firebase Console (Easiest):

1. Open this link:
   ```
   https://console.firebase.google.com/project/rcbfinal-e7f13/settings/general
   ```

2. Scroll to "Your apps" section

3. If you see a **Web app**, click on it:
   - Copy the "Web client ID" shown there

4. If you **don't see a Web app**, add one:
   - Click "Add app" → Web icon (< />)
   - App nickname: "RoboCleanerBuddy Web"
   - Click "Register app"
   - Copy the shown configuration
   - Look for `apiKey` and `authDomain`

### Using Google Cloud Console:

1. Open: https://console.cloud.google.com/

2. Select project: `rcbfinal-e7f13`

3. Go to: **APIs & Services** → **Credentials**

4. Look for **OAuth 2.0 Client IDs**

5. You should see "Web client (auto created by Google Service)"
   - Click on it
   - Copy the **Client ID**

6. If none exists:
   - Click **"+ CREATE CREDENTIALS"**
   - Choose **"OAuth 2.0 Client ID"**
   - Application type: **"Web application"**
   - Name: "RoboCleanerBuddy Web"
   - Authorized JavaScript origins:
     - `http://localhost`
     - `http://localhost:54821`
   - Click **"CREATE"**
   - Copy the **Client ID**

## After Getting Client ID:

**Tell me your Client ID** and I'll update the files for you, or:

**Update manually:**

1. Edit `web/index.html`
2. Add before `</head>`:
   ```html
   <meta name="google-signin-client_id" content="YOUR_ACTUAL_CLIENT_ID.apps.googleusercontent.com">
   ```
3. Save file
4. Restart app: `flutter run -d chrome`

## Test Again:

```bash
flutter run -d chrome
```

Click Google button → Should work! ✓

## Common Issues:

### "API not enabled"
- Go to: https://console.cloud.google.com/apis/library
- Search: "Google Sign-In API"
- Click "Enable"

### Still not working?
- Clear browser cache
- Try incognito mode
- Check Client ID is correct (no spaces, complete ID)
- Verify Firebase project is correct

## Need Help?

Share your Client ID with me and I'll update the files for you!

