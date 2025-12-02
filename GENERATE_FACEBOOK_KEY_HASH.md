# Generate Facebook Key Hash - Quick Guide 🔑

## For Windows Users (Command Prompt)

### 🚀 **Easiest Method (No OpenSSL Required)**

This method works even if you don't have OpenSSL installed!

1. **Open Command Prompt**
   - Press `Win + R`
   - Type: `cmd`
   - Press Enter

2. **Navigate to your project**
   ```cmd
   cd C:\Users\ASUS\robocleaner\android
   ```

3. **Run this command**
   ```cmd
   gradlew signingReport
   ```

4. **Wait for output** (takes 10-30 seconds)

5. **Find the SHA1 line**
   Look for something like:
   ```
   Variant: debug
   Config: debug
   Store: C:\Users\ASUS\.android\debug.keystore
   Alias: androiddebugkey
   MD5: XX:XX:XX...
   SHA1: A1:B2:C3:D4:E5:F6:G7:H8:I9:J0:K1:L2:M3:N4:O5:P6:Q7:R8:S9:T0
   SHA-256: ...
   ```

6. **Copy the SHA1 value**
   - Example: `A1:B2:C3:D4:E5:F6:G7:H8:I9:J0:K1:L2:M3:N4:O5:P6:Q7:R8:S9:T0`

7. **Remove the colons**
   - From: `A1:B2:C3:D4:E5:F6:G7:H8:I9:J0:K1:L2:M3:N4:O5:P6:Q7:R8:S9:T0`
   - To: `A1B2C3D4E5F6G7H8I9J0K1L2M3N4O5P6Q7R8S9T0`

8. **Convert to Base64**
   - Visit: https://tomeko.net/online_tools/hex_to_base64.php
   - Paste your SHA1 (without colons)
   - Click **"Convert"**
   - Copy the Base64 result

9. **Use this in Facebook**
   - Go to Facebook Developer Console
   - Settings → Basic → Android Platform
   - Paste into **"Key Hashes"** field
   - Save!

---

## 🔧 **Alternative Method (If you have OpenSSL)**

### Check if you have OpenSSL:
```cmd
openssl version
```

If it shows a version, you can use this faster method:

### Single Command Method:

```cmd
cd C:\Users\ASUS\robocleaner\android
keytool -exportcert -alias androiddebugkey -keystore "%USERPROFILE%\.android\debug.keystore" | openssl sha1 -binary | openssl base64
```

**Password:** `android`

**Output:** You'll get something like `Ab1Cd2Ef3Gh4Ij5Kl6Mn7Op8Qr9St0=`

**That's your key hash!** Copy and paste it directly into Facebook.

---

## ❓ **Troubleshooting**

### Problem: "gradlew is not recognized"

**Solution:** Make sure you're in the `android` folder:
```cmd
cd C:\Users\ASUS\robocleaner\android
dir
```
You should see `gradlew.bat` in the list.

If not, go back to project root:
```cmd
cd C:\Users\ASUS\robocleaner
cd android
```

### Problem: "keytool is not recognized"

**Solution 1:** Try using full path:
```cmd
"C:\Program Files\Android\Android Studio\jbr\bin\keytool" -exportcert -alias androiddebugkey -keystore "%USERPROFILE%\.android\debug.keystore" | openssl sha1 -binary | openssl base64
```

**Solution 2:** Use the **Easiest Method** above (gradlew signingReport)

### Problem: "Keystore file does not exist"

**Solution:** Run your app once to create the debug keystore:
```cmd
cd C:\Users\ASUS\robocleaner
flutter run
```

Wait for the app to build and launch, then try again.

### Problem: Can't find the SHA1 in output

**Solution:** The output is long. Look carefully for the "debug" variant section. 

Or redirect to a file to read easier:
```cmd
gradlew signingReport > signing_report.txt
notepad signing_report.txt
```

---

## 📋 **Quick Copy-Paste Commands**

### Navigate to project:
```cmd
cd C:\Users\ASUS\robocleaner\android
```

### Get signing report (Easiest):
```cmd
gradlew signingReport
```

### With OpenSSL (if available):
```cmd
keytool -exportcert -alias androiddebugkey -keystore "%USERPROFILE%\.android\debug.keystore" | openssl sha1 -binary | openssl base64
```

### Password when asked:
```
android
```

---

## 🎯 **What the Key Hash Looks Like**

✅ **Correct format:**
```
Ab1Cd2Ef3Gh4Ij5Kl6Mn7Op8Qr9St0=
```

❌ **Wrong format (SHA1 with colons):**
```
A1:B2:C3:D4:E5:F6:G7:H8:I9:J0:K1:L2:M3:N4:O5:P6:Q7:R8:S9:T0
```
*This needs to be converted to Base64 first!*

---

## 🔄 **Complete Process Summary**

1. Open Command Prompt
2. `cd C:\Users\ASUS\robocleaner\android`
3. `gradlew signingReport`
4. Find SHA1 in output
5. Remove colons from SHA1
6. Convert to Base64 online
7. Paste into Facebook Developer Console
8. Save
9. Done! ✅

---

## 📞 **Still Having Issues?**

### Try this diagnostic command:
```cmd
cd C:\Users\ASUS\robocleaner
flutter doctor -v
```

This shows your Android SDK path. Then you can use keytool directly:
```cmd
"C:\Users\ASUS\AppData\Local\Android\Sdk\build-tools\XX.X.X\keytool" -exportcert -alias androiddebugkey -keystore "%USERPROFILE%\.android\debug.keystore" -list -v
```

Look for the SHA1 in the output.

---

## ✅ **Success Checklist**

- [ ] Opened Command Prompt
- [ ] Navigated to android folder
- [ ] Ran gradlew signingReport
- [ ] Found SHA1 fingerprint
- [ ] Converted to Base64
- [ ] Copied key hash
- [ ] Pasted into Facebook Developer Console
- [ ] Saved changes in Facebook
- [ ] Ready to test Facebook login!

---

**Good luck! 🚀**

