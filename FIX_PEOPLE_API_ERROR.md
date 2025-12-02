# 🔧 Fix People API Error - Google Sign-In Web

## ❌ **The Error:**

```
Failed to sign in with Google: ClientException: {
  "error": {
    "code": 403,
    "message": "People API has not been used in project 374544378902 before or it is disabled..."
    "status": "PERMISSION_DENIED"
  }
}
```

**Reason:** Google People API is disabled in your Firebase project.

---

## ✅ **Solution: Enable People API**

### **Method 1: Direct Link (Fastest)**

**Click this link:**
```
https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=374544378902
```

**Then:**
1. Click the big blue **"ENABLE"** button
2. Wait 30 seconds - 2 minutes
3. Done! ✓

---

### **Method 2: From Google Cloud Console**

#### **Step 1: Open APIs Library**

```
https://console.cloud.google.com/apis/library?project=374544378902
```

#### **Step 2: Search for People API**

1. You'll see the "API Library" page
2. In the search box, type: `People API`
3. Press Enter

#### **Step 3: Enable the API**

1. Click on **"Google People API"** from results
2. You'll see:
   ```
   Google People API
   ──────────────────
   [ENABLE]  ← Click this button
   ```
3. Click **"ENABLE"**
4. Wait for the page to load (shows "API enabled")

#### **Step 4: Verify**

After enabling, you should see:
```
✓ API enabled
──────────────
[MANAGE]  [DISABLE]
```

---

### **Method 3: From Firebase Console**

#### **Step 1: Open Firebase Project**

```
https://console.firebase.google.com/project/rcbfinal-e7f13/settings/general
```

#### **Step 2: Go to Google Cloud Platform**

1. Scroll down to "Your apps" section
2. Look for a link that says **"Google Cloud Platform"** or **"Manage"**
3. Click it (opens Google Cloud Console)

#### **Step 3: Navigate to APIs**

1. In the left sidebar, find **"APIs & Services"**
2. Click **"Library"**
3. Search for **"People API"**
4. Click on it
5. Click **"ENABLE"**

---

## 🔍 **Additional APIs You Might Need:**

While you're at it, make sure these APIs are also enabled:

### **1. Identity Toolkit API** (Usually auto-enabled)
```
https://console.developers.google.com/apis/api/identitytoolkit.googleapis.com/overview?project=374544378902
```

### **2. Google+ API** (Optional, but recommended)
```
https://console.developers.google.com/apis/api/plus.googleapis.com/overview?project=374544378902
```

### **3. Cloud Firestore API** (Should already be enabled)
```
https://console.developers.google.com/apis/api/firestore.googleapis.com/overview?project=374544378902
```

---

## 🎯 **Quick Checklist:**

- [ ] Opened Google Cloud Console
- [ ] Searched for "People API"
- [ ] Clicked "ENABLE"
- [ ] Waited 1-2 minutes
- [ ] Refreshed your app
- [ ] Tried Google Sign-In again
- [ ] Success! ✓

---

## 🚀 **After Enabling - Test:**

### **Step 1: Refresh Your App**

Close and restart your Flutter web app:

```bash
# Stop the current app (Ctrl+C in terminal)
# Then restart:
flutter run -d chrome
```

### **Step 2: Try Google Sign-In**

1. Click "Sign In with Google"
2. Select your Google account
3. Should work now! ✓

---

## ⏱️ **Wait Time:**

After enabling the API:
- **Minimum:** 30 seconds
- **Average:** 1-2 minutes
- **Maximum:** 5 minutes

If it still doesn't work after 5 minutes, try:
1. Clear browser cache
2. Restart Flutter app
3. Use incognito/private browsing mode

---

## 🐛 **Still Getting Errors?**

### **Error: "API has not been used in project..."**

**Solution:** Wait a bit longer (up to 5 minutes) for the API to propagate.

### **Error: "Access Not Configured"**

**Solution:** Make sure you're enabling the API for the correct project (`374544378902`).

### **Error: "Invalid Client"**

**Solution:** Check that your OAuth Client ID is correctly configured:
```
https://console.cloud.google.com/apis/credentials?project=374544378902
```

---

## 📱 **APIs Status Dashboard:**

To check all enabled APIs:

```
https://console.cloud.google.com/apis/dashboard?project=374544378902
```

You should see:
- ✓ People API
- ✓ Identity Toolkit API
- ✓ Cloud Firestore API
- ✓ Firebase Authentication API

---

## 🎉 **Summary:**

**Your Project Number:** `374544378902`

**What You Need to Do:**
1. **Enable People API:** https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=374544378902
2. Click **"ENABLE"**
3. Wait 1-2 minutes
4. Restart your app
5. **Google Sign-In works!** ✓

---

## 📸 **What You Should See:**

### **Before Enabling:**
```
Google People API
──────────────────
[ENABLE]  ← Click this
```

### **After Enabling:**
```
✓ API enabled
──────────────────
Requests    Errors    Latency
    0          0         0ms

[MANAGE]  [DISABLE]  [TRY THIS API]
```

---

## 🔗 **Quick Links:**

### **Enable People API (Direct):**
```
https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=374544378902
```

### **API Library:**
```
https://console.cloud.google.com/apis/library?project=374544378902
```

### **APIs Dashboard:**
```
https://console.cloud.google.com/apis/dashboard?project=374544378902
```

### **OAuth Credentials:**
```
https://console.cloud.google.com/apis/credentials?project=374544378902
```

---

## ✅ **That's It!**

Once you enable the People API, Google Sign-In will work perfectly on web! 🎉

**Need help?** Let me know if you see any other errors!

