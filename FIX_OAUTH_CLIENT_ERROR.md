# Fix OAuth Client Error - Step by Step

## Your Error:
```
Error 401: invalid_client
The OAuth client was not found.
```

## Your Client ID:
```
374544378902-in2gt776a91bqf158djhc41pv9uhi83o.apps.googleusercontent.com
```

## What's Wrong:
This Client ID is not configured to allow sign-ins from `localhost`. Google blocks it for security.

## Quick Fix (3 Steps):

### Step 1: Open Google Cloud Console

**Click this link:**
```
https://console.cloud.google.com/apis/credentials?project=rcbfinal-e7f13
```

### Step 2: Configure Your OAuth Client

1. In the "OAuth 2.0 Client IDs" section, look for your client:
   - Name might be "Web client" or similar
   - Client ID: `374544378902-in2gt776a91bqf158djhc41pv9uhi83o`

2. **Click on the client name** to edit it

3. In "Authorized JavaScript origins", **ADD these URLs:**
   ```
   http://localhost
   http://localhost:54821
   http://localhost:8080
   ```
   
   **Important:** Add each URL separately by clicking "+ ADD URI"

4. In "Authorized redirect URIs", **ADD:**
   ```
   http://localhost
   ```

5. **Click "SAVE"** at the bottom

### Step 3: Restart Your App

```bash
# Stop current app (Ctrl+C)
flutter run -d chrome
```

**Try Google Sign-In again** - Should work now! ✓

---

## Alternative: Create New Web Client

If you can't find or edit the existing client, create a new one:

### In Google Cloud Console:

1. Click **"+ CREATE CREDENTIALS"**
2. Select **"OAuth 2.0 Client ID"**
3. Application type: **"Web application"**
4. Name: **"RoboCleanerBuddy Web Local"**
5. **Authorized JavaScript origins:**
   - Click "+ ADD URI"
   - Add: `http://localhost`
   - Click "+ ADD URI" again
   - Add: `http://localhost:54821`
6. **Authorized redirect URIs:**
   - Click "+ ADD URI"
   - Add: `http://localhost`
7. Click **"CREATE"**
8. **Copy the new Client ID**
9. **Update in `web/index.html`**
10. **Restart app**

---

## Visual Guide:

```
Google Cloud Console
    ↓
APIs & Services → Credentials
    ↓
Find your OAuth 2.0 Client
    ↓
Click on it to edit
    ↓
Authorized JavaScript origins:
    + ADD URI: http://localhost
    + ADD URI: http://localhost:54821
    ↓
Click SAVE
    ↓
Restart Flutter app
    ↓
✅ Works!
```

---

## Important Notes:

### Authorized JavaScript Origins:
These tell Google where your app is running from. For local development:
- ✅ `http://localhost` (no port = allows any port)
- ✅ `http://localhost:54821` (specific port)
- ❌ `http://localhost/` (trailing slash = won't work)

### Common Mistakes:
- ❌ Not clicking SAVE after adding origins
- ❌ Adding `https://localhost` (should be `http://`)
- ❌ Adding trailing slashes
- ❌ Not restarting the app after changes

---

## After Fixing:

The Google Sign-In should:
1. Open popup ✓
2. Show Google account selection ✓
3. Sign in successfully ✓
4. Navigate to dashboard ✓

No more "invalid_client" error!

