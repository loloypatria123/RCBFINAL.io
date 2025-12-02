# How to Get Your Google OAuth Client ID

## Quick Steps (5 minutes)

### Method 1: From Firebase Console (Recommended)

1. **Go to Firebase Console:**
   ```
   https://console.firebase.google.com/project/rcbfinal-e7f13/authentication/providers
   ```

2. **Click on Google Sign-In Provider:**
   - You should see it's already enabled
   - Look for **"Web SDK configuration"** section
   - You'll see **"Web client ID"**
   - Copy this ID (it looks like: `123456789-abcdefgh.apps.googleusercontent.com`)

### Method 2: From Google Cloud Console

1. **Go to Google Cloud Console:**
   ```
   https://console.cloud.google.com/apis/credentials?project=rcbfinal-e7f13
   ```

2. **Find Web Client:**
   - Look for OAuth 2.0 Client IDs
   - Find one that says "Web client (auto created by Google Service)"
   - Click on it
   - Copy the **Client ID**

3. **If No Web Client Exists, Create One:**
   - Click **"+ CREATE CREDENTIALS"**
   - Select **"OAuth 2.0 Client ID"**
   - Application type: **"Web application"**
   - Name: "RoboCleanerBuddy Web"
   - Authorized JavaScript origins:
     - Add: `http://localhost`
     - Add: `http://localhost:54821` (or your current port)
   - Click **"CREATE"**
   - Copy the **Client ID**

## Your Client ID Format

It should look like this:
```
123456789012-abc1def2ghi3jkl4mno5pqr6stu7vwx8.apps.googleusercontent.com
```

## Next Step

Once you have your Client ID, add it to `web/index.html` (I'll do this for you once you provide it).

