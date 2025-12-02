# Setup Privacy Policy & Data Deletion URLs for Facebook 🔒

## ✅ Files Created!

I've created both required files:
- **Privacy Policy:** `web/privacy-policy.html`
- **Data Deletion Instructions:** `web/data-deletion-instructions.html`

Now you need to host them and get URLs for Facebook.

---

## 🚀 **Option 1: Firebase Hosting (Recommended - FREE)**

### Step 1: Install Firebase CLI (if not installed)

```powershell
npm install -g firebase-tools
```

### Step 2: Login to Firebase

```powershell
firebase login
```

### Step 3: Initialize Firebase Hosting (if not already done)

```powershell
cd C:\Users\ASUS\robocleaner
firebase init hosting
```

**When prompted:**
- Select: **"Use an existing project"**
- Select: **"rcbfinal-e7f13"**
- Public directory: **"web"** (or press Enter if it suggests web)
- Configure as single-page app: **"No"**
- Set up automatic builds: **"No"**

### Step 4: Deploy

```powershell
firebase deploy --only hosting
```

### Step 5: Your URLs

After deployment, both pages will be available at:

**Privacy Policy URL:**
```
https://rcbfinal-e7f13.web.app/privacy-policy.html
```

**Data Deletion Instructions URL:**
```
https://rcbfinal-e7f13.web.app/data-deletion-instructions.html
```

**Use both URLs in Facebook Developer Console!**

---

## 🌐 **Option 2: GitHub Pages (FREE)**

### Step 1: Create a GitHub repository (if you don't have one)

1. Go to https://github.com
2. Create a new repository
3. Name it: `robocleaner-privacy-policy`

### Step 2: Upload the file

1. Upload `web/privacy-policy.html` to the repository
2. Rename it to `index.html` (or keep it as is)

### Step 3: Enable GitHub Pages

1. Go to repository **Settings**
2. Scroll to **Pages**
3. Source: Select **"main"** branch
4. Folder: **"/ (root)"**
5. Click **Save**

### Step 4: Your Privacy Policy URL

After a few minutes, your privacy policy will be at:

```
https://YOUR_USERNAME.github.io/robocleaner-privacy-policy/privacy-policy.html
```

Or if you renamed it to `index.html`:

```
https://YOUR_USERNAME.github.io/robocleaner-privacy-policy/
```

---

## 📝 **Option 3: Use a Free Privacy Policy Generator**

### Quick Option: Use a Generator Service

1. Go to: https://www.freeprivacypolicy.com/
2. Fill in your app details
3. Generate privacy policy
4. Copy the HTML
5. Host it anywhere (Firebase, GitHub, etc.)

---

## 🔗 **Option 4: Use Your Existing Website**

If you already have a website:

1. Upload `web/privacy-policy.html` to your web server
2. Access it via: `https://yourdomain.com/privacy-policy.html`

---

## ✅ **After You Have the URLs**

### Add to Facebook Developer Console:

1. Go to: https://developers.facebook.com/
2. Select your app
3. Go to **Settings** → **Basic**
4. Find **"Privacy Policy URL"** field
   - Paste: `https://rcbfinal-e7f13.web.app/privacy-policy.html`
5. Find **"Data deletion instructions URL"** field
   - Paste: `https://rcbfinal-e7f13.web.app/data-deletion-instructions.html`
6. Click **"Save Changes"**

---

## 🎯 **Quickest Solution (5 minutes)**

### Use Firebase Hosting:

```powershell
# 1. Install Firebase CLI (one time)
npm install -g firebase-tools

# 2. Login
firebase login

# 3. Initialize hosting (if not done)
cd C:\Users\ASUS\robocleaner
firebase init hosting
# Select: Use existing project → rcbfinal-e7f13
# Public directory: web
# Single-page app: No

# 4. Deploy
firebase deploy --only hosting

# 5. Your URLs will be:
# Privacy Policy: https://rcbfinal-e7f13.web.app/privacy-policy.html
# Data Deletion: https://rcbfinal-e7f13.web.app/data-deletion-instructions.html
```

---

## 📋 **Checklist**

- [x] Privacy policy HTML file created
- [x] Data deletion instructions HTML file created
- [ ] Both files hosted online
- [ ] URLs obtained
- [ ] Privacy Policy URL added to Facebook Developer Console
- [ ] Data Deletion Instructions URL added to Facebook Developer Console
- [ ] Facebook app settings saved

---

## 🔍 **Verify Your Privacy Policy**

After hosting, visit your URL in a browser to make sure it loads correctly.

**Example URLs:**
- Firebase Privacy Policy: `https://rcbfinal-e7f13.web.app/privacy-policy.html`
- Firebase Data Deletion: `https://rcbfinal-e7f13.web.app/data-deletion-instructions.html`
- GitHub Pages: `https://username.github.io/repo/privacy-policy.html`
- Custom domain: `https://yourdomain.com/privacy-policy.html`

---

## ⚠️ **Important Notes**

1. **The URL must be publicly accessible** - Facebook needs to verify it
2. **HTTPS is required** - Must use `https://` not `http://`
3. **Must be a real URL** - Cannot be a placeholder or "coming soon" page
4. **Keep it updated** - Update the "Last Updated" date when you make changes

---

## 🆘 **Troubleshooting**

### Problem: "Invalid URL" in Facebook

**Solution:**
- Make sure URL starts with `https://`
- URL must be publicly accessible (not localhost)
- Try opening the URL in an incognito browser window

### Problem: Firebase deploy fails

**Solution:**
- Make sure you're logged in: `firebase login`
- Check if hosting is initialized: `firebase.json` should have hosting config
- Verify you have the correct project selected

### Problem: Privacy policy doesn't load

**Solution:**
- Check file name matches URL exactly
- Verify file is in the correct directory
- Check Firebase Hosting console for errors

---

## 📞 **Need Help?**

If you need assistance with any step, let me know! I can help you:
- Set up Firebase Hosting
- Deploy the privacy policy
- Verify the URL works
- Update the privacy policy content

---

**Once you have both URLs, paste them into Facebook Developer Console and you're done! ✅**

---

## 📝 **What's in the Data Deletion Instructions?**

The data deletion page includes:
- ✅ Step-by-step instructions for deleting account
- ✅ Multiple methods (app, email, third-party)
- ✅ What data will be deleted
- ✅ Processing timeframes
- ✅ Contact information
- ✅ User rights information
- ✅ Warnings about permanent deletion

