# 📥 Download google-services.json - Step by Step

## Your App Information:
- **Package Name:** `com.example.robocleaner`
- **SHA-1:** `5A:3D:9B:04:E9:C6:5D:DD:E4:24:D1:FE:58:C0:FC:DD:A2:00:7E:86`

---

## 🚀 Complete Process (5 Minutes):

### **Step 1: Open Firebase Console**

**Click this direct link:**
```
https://console.firebase.google.com/project/rcbfinal-e7f13/settings/general
```

You should see the Firebase project page.

---

### **Step 2: Add Android App (If Not Added Yet)**

Scroll down to **"Your apps"** section. 

#### **If you DON'T see an Android app (green robot icon):**

1. Click the **"Add app"** button (big button with + icon)

2. Click the **Android icon** (green robot 🤖)

3. **Fill in the form:**
   ```
   Android package name: com.example.robocleaner
   App nickname (optional): RoboCleanerBuddy
   ```

4. Click **"Register app"**

5. **You'll see a screen with google-services.json** - Click **"Download google-services.json"**
   - Save it to your Downloads folder

6. Click **"Next"** → **"Next"** → **"Continue to console"**

#### **If you ALREADY see an Android app:**

Skip to Step 3 below.

---

### **Step 3: Add SHA-1 Fingerprint**

1. **Find your Android app** in the "Your apps" section

2. **Click on the app** to expand it (click anywhere on the app card)

3. You'll see:
   ```
   App ID: 1:123456:android:...
   Package name: com.example.robocleaner
   SHA certificate fingerprints:
   ```

4. **Scroll to "SHA certificate fingerprints"**

5. Click **"Add fingerprint"** button

6. **Paste your SHA-1:**
   ```
   5A:3D:9B:04:E9:C6:5D:DD:E4:24:D1:FE:58:C0:FC:DD:A2:00:7E:86
   ```

7. Press **Enter** or click outside the input field

8. Click **"Save"** button at the bottom of the page

---

### **Step 4: Download google-services.json**

After saving SHA-1:

#### **Option A: From the Android App Card**

1. Still on the same page
2. Look at your Android app card
3. Find the **"google-services.json"** button or link
4. Click it to download

#### **Option B: From App Settings**

1. Click the **gear icon (⚙️)** next to your Android app
2. Select **"General"** or **"App settings"**
3. Scroll down
4. Find **"google-services.json"** download button
5. Click to download

#### **Option C: Re-add App (If Can't Find Download)**

1. Click the **three dots (⋮)** next to your Android app
2. Note down all your settings
3. Delete the app
4. Add it again (Steps from Step 2)
5. During setup, you'll see the download button
6. Add SHA-1 again after re-creating

---

### **Step 5: Replace the File**

**The downloaded file is in:** `C:\Users\ASUS\Downloads\google-services.json`

**Replace it here:** `C:\Users\ASUS\robocleaner\android\app\google-services.json`

#### **Quick Copy (PowerShell):**
```powershell
Copy-Item "$env:USERPROFILE\Downloads\google-services.json" -Destination "android\app\google-services.json" -Force
```

#### **Or Manually:**
1. Open File Explorer
2. Go to Downloads folder
3. Find `google-services.json` (just downloaded)
4. Copy it (Ctrl+C)
5. Navigate to: `C:\Users\ASUS\robocleaner\android\app\`
6. Paste (Ctrl+V)
7. Choose "Replace" when prompted

---

### **Step 6: Verify File is Correct**

Open the file: `android\app\google-services.json`

Check if it contains your package name:
```json
{
  "project_info": {...},
  "client": [
    {
      "client_info": {
        "android_client_info": {
          "package_name": "com.example.robocleaner"  ← Should match!
        }
      }
    }
  ]
}
```

Also check for `client_id` fields - these should be populated.

---

### **Step 7: Rebuild and Test**

```bash
# Already cleaned for you!
flutter pub get
flutter run
```

**Then test:**
1. App opens on your Android device
2. Click **Google** button  
3. Google account picker appears
4. Select account
5. **Success!** ✓ Signed in and redirected to dashboard!

---

## 📸 **What You Should See in Firebase:**

```
┌───────────────────────────────────────────────────┐
│ Your apps                                         │
├───────────────────────────────────────────────────┤
│                                                   │
│  🌐 Web app                                       │
│     App ID: ...                                   │
│     [⚙️] [⋮]                                      │
│                                                   │
│  🤖 RoboCleanerBuddy (Android)                   │
│     App ID: 1:123456:android:...                 │
│     Package: com.example.robocleaner             │
│     ──────────────────────────────────           │
│     SHA certificate fingerprints:                │
│       5A:3D:9B:04:... ✓                          │
│     ──────────────────────────────────           │
│     [google-services.json] ← CLICK TO DOWNLOAD   │
│     [⚙️] [⋮]                                      │
│                                                   │
└───────────────────────────────────────────────────┘
```

---

## 🔍 **Can't Find Download Button?**

### Try These:

1. **Click the gear icon (⚙️)** next to your Android app
   - Select "Download config file"

2. **Click the three dots (⋮)** next to your Android app
   - Look for "Download google-services.json"

3. **Go to Project Overview:**
   - Click "Project Overview" (home icon)
   - Click on your Android app
   - Find download option

4. **Re-register the app:**
   - Delete and re-add Android app
   - During setup, download will be offered

---

## 📱 **Direct Links:**

### **Firebase Project Settings:**
```
https://console.firebase.google.com/project/rcbfinal-e7f13/settings/general
```

### **Firebase Project Overview:**
```
https://console.firebase.google.com/project/rcbfinal-e7f13/overview
```

---

## ✅ **After Downloading:**

### **Verify Your File:**

The `google-services.json` should contain:

```json
{
  "project_info": {
    "project_number": "374544378902",
    "project_id": "rcbfinal-e7f13"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:374544378902:android:...",
        "android_client_info": {
          "package_name": "com.example.robocleaner"
        }
      },
      "oauth_client": [
        {
          "client_id": "374544378902-...apps.googleusercontent.com",
          "client_type": 3
        }
      ]
    }
  ]
}
```

If you see this structure with your package name, **it's correct!** ✓

---

## 🎯 **Quick Checklist:**

- [ ] Opened Firebase Console
- [ ] Found "Your apps" section
- [ ] Android app exists (or created new one)
- [ ] Added SHA-1 fingerprint
- [ ] Clicked "Save"
- [ ] Found download button for google-services.json
- [ ] Downloaded the file
- [ ] File is in Downloads folder
- [ ] Copied to: `android/app/google-services.json`
- [ ] Verified file contains correct package name
- [ ] Ready to run: `flutter run`

---

## 🐛 **Troubleshooting:**

### **Can't Find Android App in Firebase:**

**Create one now:**
1. Click "Add app" in Firebase Console
2. Android icon
3. Package: `com.example.robocleaner`
4. Register
5. Download appears immediately

### **Download Button Not Visible:**

**Try this:**
1. Click gear icon (⚙️) next to Android app
2. Or refresh the page
3. Or try from Project Overview instead of Settings

### **Wrong Package Name in File:**

**Re-download with correct package:**
1. Check your package in `android/app/build.gradle.kts`
2. Should be: `com.example.robocleaner`
3. Make sure Firebase Android app has same package name
4. Re-download

---

## 🎉 **Summary:**

**Your Info:**
- Package: `com.example.robocleaner`
- SHA-1: `5A:3D:9B:04:E9:C6:5D:DD:E4:24:D1:FE:58:C0:FC:DD:A2:00:7E:86`

**What to Do:**
1. Open Firebase Console
2. Add/Find Android app
3. Add SHA-1
4. Download google-services.json
5. Place in: `android/app/google-services.json`
6. Run: `flutter run`
7. **Google Sign-In works!** ✓

**Need help?** Let me know which step you're stuck on!

