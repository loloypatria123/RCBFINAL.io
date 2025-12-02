# Facebook Development Mode Setup for Testing 🧪

## Overview

Development mode allows you to test Facebook Login without completing business verification. Only you and added test users can use the app.

---

## ✅ **Advantages of Development Mode**

- ✅ No business verification required
- ✅ No website verification needed
- ✅ Quick setup for testing
- ✅ Only test users can access (more secure for testing)
- ✅ Can switch to Live mode later

---

## 📋 **Step 1: Keep App in Development Mode**

1. Go to Facebook Developer Console
2. Select your app
3. At the top, you'll see app status toggle
4. Make sure it says **"Development"** (not "Live")
5. If it says "Live", click to switch back to "Development"

---

## 📋 **Step 2: Add Test Users**

Since your app is in Development mode, only test users can sign in.

### Option A: Add Yourself as Test User

1. Go to **Roles** → **Roles** in left sidebar
2. Click **"Add People"**
3. Enter your Facebook account email
4. Select role: **"Administrator"** or **"Developer"**
5. Click **"Add"**
6. You'll receive an email invitation
7. Accept the invitation

### Option B: Create Test Users

1. Go to **Roles** → **Test Users** in left sidebar
2. Click **"Add"** or **"Create Test User"**
3. Facebook will create a test user automatically
4. Click **"Edit"** to set password
5. Note down the test user credentials

### Option C: Use Your Personal Facebook Account

If you're an admin/developer, you can use your own Facebook account to test!

---

## 📋 **Step 3: Skip Business Verification (For Now)**

In Development mode, you can:
- ✅ Skip business details form
- ✅ Skip website verification
- ✅ Skip phone verification
- ✅ Test Facebook Login immediately

Just make sure your app is in **Development** mode.

---

## 📋 **Step 4: Configure Facebook Login for Development**

### Basic Settings (Already Done)

- ✅ App ID: `1556967962012960`
- ✅ App Secret: (configured in Firebase)
- ✅ Client Token: `8b69f7ebaa1608beae88450b331c3d43`
- ✅ Android package name: `com.example.robocleaner`
- ✅ Key hash: (added to Facebook)

### Development Mode Settings

1. Go to **Settings** → **Basic**
2. Make sure **App Mode** is set to **"Development"**
3. **App Domains**: Can leave empty for now
4. **Privacy Policy URL**: Optional in development mode
5. **Data Deletion URL**: Optional in development mode

---

## 📋 **Step 5: Test Facebook Login**

### On Android:

1. Build and run your app:
   ```powershell
   flutter run
   ```

2. Navigate to Sign-In page
3. Click Facebook button
4. Use your test user account or your admin account
5. Grant permissions
6. Should redirect back to app successfully!

### On Web:

1. Run web app:
   ```powershell
   flutter run -d chrome
   ```

2. Navigate to Sign-In page
3. Click Facebook button
4. Login with test user
5. Should work!

---

## 📋 **Step 6: Add More Test Users (Optional)**

If you want others to test:

1. Go to **Roles** → **Test Users**
2. Click **"Create Test User"**
3. Share credentials with testers
4. Or add them as developers/admins

---

## ⚠️ **Development Mode Limitations**

- ❌ Only test users and admins/developers can sign in
- ❌ Regular Facebook users cannot use the app
- ❌ Limited to 50 test users
- ❌ Some advanced features may be restricted

---

## 🔄 **Switching to Live Mode Later**

When you're ready to publish:

1. Complete business verification
2. Add proper website URL
3. Complete all required forms
4. Switch app to **"Live"** mode
5. Submit for App Review (if needed)

---

## ✅ **Development Mode Checklist**

- [ ] App is in Development mode
- [ ] Added yourself as admin/developer
- [ ] Created test users (if needed)
- [ ] Facebook Login configured
- [ ] Android key hash added
- [ ] Tested login on Android
- [ ] Tested login on Web (if applicable)

---

## 🧪 **Testing Scenarios**

### Test 1: First-Time Login
- New user signs in with Facebook
- Should create account in Firestore
- Should redirect to dashboard

### Test 2: Returning User
- Existing user signs in again
- Should load existing account
- Should redirect to dashboard

### Test 3: Cancel Login
- User clicks Facebook button
- User cancels Facebook login
- Should return to sign-in page
- Should show appropriate message

### Test 4: Permissions
- User grants email permission
- User grants public_profile permission
- Should retrieve user data successfully

---

## 🐛 **Common Development Mode Issues**

### Problem: "App Not Setup"

**Solution:**
- Make sure app is in Development mode
- Add yourself as admin/developer
- Wait a few minutes after changes

### Problem: "Invalid Key Hash"

**Solution:**
- Verify key hash is correct in Facebook Console
- Rebuild app after adding key hash
- Check AndroidManifest.xml configuration

### Problem: "User Not Authorized"

**Solution:**
- Make sure you're using a test user or admin account
- Regular Facebook users can't use Development mode apps
- Add yourself to Roles if needed

### Problem: "Redirect URI Mismatch"

**Solution:**
- Check OAuth redirect URI in Firebase
- Verify it's added to Facebook Console
- Make sure URLs match exactly

---

## 📝 **Quick Reference**

### Development Mode Status:
- **Current Mode**: Development ✅
- **Test Users**: Unlimited (up to 50)
- **Business Verification**: Not Required
- **Website Required**: No
- **App Review**: Not Required

### Your Test Accounts:
- **Your Facebook Account**: Can use (if admin/developer)
- **Test Users**: Create in Roles → Test Users
- **Regular Users**: Cannot use (until Live mode)

---

## 🎯 **Next Steps**

1. ✅ Keep app in Development mode
2. ✅ Add yourself as admin/developer
3. ✅ Test Facebook Login
4. ✅ Verify user data is saved correctly
5. ✅ Test on both Android and Web
6. ✅ When ready, switch to Live mode

---

## 🎉 **You're Ready!**

With Development mode, you can:
- Test Facebook Login immediately
- Skip business verification
- Add test users easily
- Switch to Live mode when ready

**Start testing your Facebook Login now!** 🚀

---

## 📞 **Need Help?**

If you encounter issues:
1. Check app is in Development mode
2. Verify you're using test user or admin account
3. Check Facebook Console for error messages
4. Review AndroidManifest.xml configuration
5. Verify key hash is correct

Happy testing! 🎊

