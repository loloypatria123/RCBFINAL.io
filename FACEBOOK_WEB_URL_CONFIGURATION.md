# Facebook Web URL Configuration Guide 🔧

## Important: Site URL vs OAuth Redirect URI

These are **two different things** that need to be configured separately:

### 1. **Site URL** (Website Platform)
- This is your main website URL
- Used for: Website platform configuration
- Example: `https://rcbfinal-e7f13.firebaseapp.com`

### 2. **OAuth Redirect URI** (Facebook Login Settings)
- This is where Facebook redirects after authentication
- Used for: Facebook Login OAuth flow
- Example: `https://rcbfinal-e7f13.firebaseapp.com/__/auth/handler`

---

## ✅ **Correct Configuration**

### **Step 1: Add Website Platform**

1. Go to Facebook Developer Console
2. **Settings** → **Basic**
3. Scroll to **"Platforms"** section
4. Click **"+ Add Platform"** → **"Website"**
5. **Site URL**: Enter:
   ```
   https://rcbfinal-e7f13.firebaseapp.com
   ```
   **OR**
   ```
   https://rcbfinal-e7f13.web.app
   ```
   (Use one of these, not the `/__/auth/handler` path)
6. Click **"Save Changes"**

### **Step 2: Add OAuth Redirect URI**

1. Go to **Facebook Login** → **Settings**
2. Find **"Valid OAuth Redirect URIs"**
3. Add this URI:
   ```
   https://rcbfinal-e7f13.firebaseapp.com/__/auth/handler
   ```
4. Also add (for web.app domain):
   ```
   https://rcbfinal-e7f13.web.app/__/auth/handler
   ```
5. Click **"Save Changes"**

### **Step 3: Add App Domains**

1. Go to **Settings** → **Basic**
2. Find **"App Domains"**
3. Add:
   ```
   rcbfinal-e7f13.firebaseapp.com
   rcbfinal-e7f13.web.app
   ```
4. Click **"Save Changes"**

---

## 📋 **Summary of URLs**

### **Website Platform - Site URL:**
```
https://rcbfinal-e7f13.firebaseapp.com
```
OR
```
https://rcbfinal-e7f13.web.app
```

### **OAuth Redirect URIs:**
```
https://rcbfinal-e7f13.firebaseapp.com/__/auth/handler
https://rcbfinal-e7f13.web.app/__/auth/handler
```

### **App Domains:**
```
rcbfinal-e7f13.firebaseapp.com
rcbfinal-e7f13.web.app
```

---

## 🎯 **Quick Configuration Steps**

1. **Website Platform:**
   - Settings → Basic → Add Platform → Website
   - Site URL: `https://rcbfinal-e7f13.firebaseapp.com`
   - Save

2. **OAuth Redirect URI:**
   - Facebook Login → Settings
   - Add: `https://rcbfinal-e7f13.firebaseapp.com/__/auth/handler`
   - Save

3. **App Domains:**
   - Settings → Basic → App Domains
   - Add: `rcbfinal-e7f13.firebaseapp.com`
   - Save

---

## ⚠️ **Common Mistake**

**WRONG:**
- Using `/__/auth/handler` as Site URL ❌

**CORRECT:**
- Site URL: `https://rcbfinal-e7f13.firebaseapp.com` ✅
- OAuth Redirect URI: `https://rcbfinal-e7f13.firebaseapp.com/__/auth/handler` ✅

---

## 🔍 **Why This Matters**

- **Site URL**: Tells Facebook where your website is hosted
- **OAuth Redirect URI**: Tells Facebook where to send users after they authenticate
- Both are required for Facebook Login to work on web

---

## ✅ **After Configuration**

1. Wait 2-3 minutes for changes to propagate
2. Clear browser cache
3. Restart your Flutter app
4. Try Facebook login again

---

## 🧪 **Test Your Configuration**

1. Visit: `https://rcbfinal-e7f13.firebaseapp.com`
   - Should load your app ✅

2. Visit: `https://rcbfinal-e7f13.firebaseapp.com/__/auth/handler`
   - Should show Firebase auth handler page ✅

Both URLs should be accessible!

---

## 📝 **Checklist**

- [ ] Website platform added with Site URL (not `/__/auth/handler`)
- [ ] OAuth Redirect URI added (`/__/auth/handler`)
- [ ] App Domains configured
- [ ] App in Development mode
- [ ] You're added as admin/developer
- [ ] Firebase Facebook enabled
- [ ] Waited 2-3 minutes after changes
- [ ] Cleared browser cache
- [ ] Restarted Flutter app

---

**Make sure you use the correct URLs in the correct places!** 🚀

