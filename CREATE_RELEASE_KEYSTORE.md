# Create Release Keystore & Generate Facebook Key Hash 🔐

## Overview

A release keystore is required to:
1. Sign your app for Google Play Store
2. Generate Facebook release key hash
3. Enable Google Sign-In in production

## 📋 **Step 1: Create Release Keystore**

### Using keytool (Recommended)

1. **Open Command Prompt or PowerShell**

2. **Navigate to your android/app folder:**
   ```cmd
   cd C:\Users\ASUS\robocleaner\android\app
   ```

3. **Run the keytool command:**
   
   ```cmd
   "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

4. **Fill in the information when prompted:**

   ```
   Enter keystore password: [Enter a strong password - SAVE THIS!]
   Re-enter new password: [Same password]
   
   What is your first and last name?
     [Unknown]: Your Name
   
   What is the name of your organizational unit?
     [Unknown]: Development
   
   What is the name of your organization?
     [Unknown]: RoboCleanerBuddy
   
   What is the name of your City or Locality?
     [Unknown]: Your City
   
   What is the name of your State or Province?
     [Unknown]: Your Province
   
   What is the two-letter country code for this unit?
     [Unknown]: PH
   
   Is CN=Your Name, OU=Development, O=RoboCleanerBuddy, L=Your City, ST=Your Province, C=PH correct?
     [no]: yes
   
   Generating 2,048 bit RSA key pair and self-signed certificate (SHA256withRSA) with a validity of 10,000 days
         for: CN=Your Name, OU=Development, O=RoboCleanerBuddy, L=Your City, ST=Your Province, C=PH
   
   Enter key password for <upload>
         (RETURN if same as keystore password): [Press ENTER to use same password]
   
   [Storing upload-keystore.jks]
   ```

5. **IMPORTANT: Save this information securely!**

   Create a file `android/key.properties` (DO NOT commit to git):
   ```properties
   storePassword=YOUR_KEYSTORE_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD
   keyAlias=upload
   storeFile=upload-keystore.jks
   ```

---

## 📋 **Step 2: Get SHA-1 from Release Keystore**

Now that you have your release keystore, get the SHA-1:

```cmd
"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -list -v -keystore C:\Users\ASUS\robocleaner\android\app\upload-keystore.jks -alias upload
```

**Enter password:** [Your keystore password]

Look for the SHA-1 line in the output:
```
Certificate fingerprints:
     SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
     SHA256: ...
```

---

## 📋 **Step 3: Convert SHA-1 to Facebook Key Hash**

### Method 1: Using PowerShell (Easiest)

Copy your SHA-1 (without colons), then run:

```powershell
$hex = "PASTE_YOUR_SHA1_HERE_WITHOUT_COLONS"
$bytes = [byte[]]::new($hex.Length / 2)
for($i=0; $i -lt $hex.Length; $i+=2) { 
    $bytes[$i/2] = [Convert]::ToByte($hex.Substring($i, 2), 16) 
}
[Convert]::ToBase64String($bytes)
```

### Method 2: Using Online Converter

1. Copy your SHA-1: `XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX`
2. Remove colons: `XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`
3. Go to: https://tomeko.net/online_tools/hex_to_base64.php
4. Paste and convert
5. Copy the Base64 result

---

## 📋 **Step 4: Configure Android Build**

Update `android/app/build.gradle.kts`:

1. **Add before `android {` block:**

```kotlin
// Load keystore properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = java.util.Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(java.io.FileInputStream(keystorePropertiesFile))
}
```

2. **Add inside `android {` block, after `defaultConfig`:**

```kotlin
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties["keyAlias"] as String
        keyPassword = keystoreProperties["keyPassword"] as String
        storeFile = file(keystoreProperties["storeFile"] as String)
        storePassword = keystoreProperties["storePassword"] as String
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        
        // Optional: Enable code shrinking and obfuscation
        isMinifyEnabled = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
```

---

## 📋 **Step 5: Add to .gitignore**

**IMPORTANT:** Add these to `android/.gitignore`:

```
key.properties
*.jks
*.keystore
```

And to root `.gitignore`:
```
android/key.properties
android/app/*.jks
android/app/*.keystore
```

---

## 📋 **Step 6: Add Release Key Hash to Facebook**

1. Go to Facebook Developer Console
2. Your App → Settings → Basic
3. Scroll to Android platform
4. In **"Key Hashes"** field, you should now have TWO hashes:
   - Debug hash (for development)
   - Release hash (for production)
5. Add both hashes separated by commas or in separate lines
6. Save Changes

---

## ✅ **Security Checklist**

- [ ] Created release keystore
- [ ] Saved keystore password securely
- [ ] Created key.properties file
- [ ] Added key.properties to .gitignore
- [ ] Added *.jks to .gitignore
- [ ] Backed up keystore file (store in secure location)
- [ ] Got SHA-1 from release keystore
- [ ] Converted to Facebook key hash
- [ ] Added to Facebook Developer Console
- [ ] Updated build.gradle.kts with signing config

---

## ⚠️ **CRITICAL: Backup Your Keystore!**

**NEVER LOSE YOUR KEYSTORE!**

If you lose it, you cannot update your app on Play Store!

**Backup locations:**
1. Secure cloud storage (Google Drive, Dropbox - in encrypted folder)
2. USB drive (in safe location)
3. Password manager (some support file storage)

**What to backup:**
- `upload-keystore.jks` file
- Keystore password
- Key alias (`upload`)
- Key password

---

## 🧪 **Test Release Build**

After setup, test your release build:

```cmd
cd C:\Users\ASUS\robocleaner
flutter build apk --release
```

Or for app bundle (recommended for Play Store):

```cmd
flutter build appbundle --release
```

---

## 📞 **Troubleshooting**

### Problem: "keytool not found"

**Solution:** Use full path:
```cmd
"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe"
```

### Problem: "Keystore was tampered with, or password was incorrect"

**Solution:** 
- Double-check password (case-sensitive)
- Make sure you're using the correct keystore file
- Verify the alias is correct (`upload`)

### Problem: Build fails with "Keystore file not found"

**Solution:**
- Check `storeFile` path in `key.properties`
- Should be relative to `android/app/`: `storeFile=upload-keystore.jks`
- OR absolute path: `storeFile=/full/path/to/upload-keystore.jks`

### Problem: "Cannot find key.properties"

**Solution:**
- Make sure file is at: `android/key.properties`
- Check file name (no spaces, lowercase)
- File should be in `android` folder, not `android/app`

---

## 📚 **Quick Reference**

### Your Release Keystore Information:

```
File Location: android/app/upload-keystore.jks
Key Alias: upload
Validity: 10,000 days (~27 years)
```

### Command to View Keystore Info:

```cmd
"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -list -v -keystore android\app\upload-keystore.jks -alias upload
```

### Command to Get SHA-1 Only:

```cmd
"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -list -v -keystore android\app\upload-keystore.jks -alias upload | findstr SHA1:
```

---

## 🎯 **Summary**

After completing these steps, you will have:

✅ Release keystore for signing your app  
✅ SHA-1 fingerprint for Google Services  
✅ Facebook release key hash  
✅ Properly configured build.gradle  
✅ Secure backup of keystore  
✅ Ready for Play Store release  

---

**Good luck with your release! 🚀**

