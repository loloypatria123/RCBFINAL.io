# Setup GitHub Pages for Facebook Business Verification 🚀

## Overview

This guide will help you create a free website using GitHub Pages that Facebook will accept for business verification.

---

## 📋 **Step 1: Create GitHub Account (if you don't have one)**

1. Go to: https://github.com
2. Click **"Sign up"**
3. Create your account (it's free)
4. Verify your email address

---

## 📋 **Step 2: Create a New Repository**

1. After logging in, click the **"+"** icon in the top right
2. Select **"New repository"**

3. Fill in the details:
   - **Repository name**: `robocleaner-website` (or any name you prefer)
   - **Description**: `RoboCleanerBuddy Official Website` (optional)
   - **Visibility**: Select **"Public"** (required for free GitHub Pages)
   - **DO NOT** check "Add a README file" (we'll add files manually)
   - **DO NOT** add .gitignore or license

4. Click **"Create repository"**

---

## 📋 **Step 3: Create the Website Files**

### Option A: Create Files Directly on GitHub (Easiest)

1. In your new repository, click **"creating a new file"** (or the pencil icon)

2. **Create `index.html` file:**
   - File name: `index.html`
   - Copy and paste this content:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RoboCleanerBuddy - Official Website</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #1a1a1a;
            border-bottom: 3px solid #007bff;
            padding-bottom: 10px;
        }
        .nav {
            margin: 20px 0;
        }
        .nav a {
            color: #007bff;
            text-decoration: none;
            margin-right: 20px;
        }
        .nav a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>RoboCleanerBuddy</h1>
        
        <div class="nav">
            <a href="index.html">Home</a>
            <a href="privacy-policy.html">Privacy Policy</a>
            <a href="data-deletion-instructions.html">Data Deletion</a>
        </div>
        
        <h2>Welcome to RoboCleanerBuddy</h2>
        <p>
            RoboCleanerBuddy is a mobile application that helps you manage and control 
            your cleaning robot. Our app provides an intuitive interface for scheduling 
            cleaning tasks, monitoring robot status, and managing your home automation.
        </p>
        
        <h2>Features</h2>
        <ul>
            <li>Easy robot control and management</li>
            <li>Schedule cleaning tasks</li>
            <li>Real-time status monitoring</li>
            <li>Secure authentication with Google and Facebook</li>
            <li>User-friendly interface</li>
        </ul>
        
        <h2>Download</h2>
        <p>
            RoboCleanerBuddy is available for Android and iOS devices. 
            Download from Google Play Store or Apple App Store.
        </p>
        
        <h2>Contact Us</h2>
        <p>
            For support or inquiries, please contact us at: 
            <strong>support@robocleanerbuddy.com</strong>
        </p>
        
        <h2>Legal</h2>
        <ul>
            <li><a href="privacy-policy.html">Privacy Policy</a></li>
            <li><a href="data-deletion-instructions.html">Data Deletion Instructions</a></li>
        </ul>
    </div>
</body>
</html>
```

3. Scroll down and click **"Commit new file"**
   - Leave the commit message as is
   - Click the green **"Commit new file"** button

4. **Create `privacy-policy.html` file:**
   - Click **"Add file"** → **"Create new file"**
   - File name: `privacy-policy.html`
   - Copy the content from: `web/privacy-policy.html` in your project
   - Or use the same content we created earlier
   - Click **"Commit new file"**

5. **Create `data-deletion-instructions.html` file:**
   - Click **"Add file"** → **"Create new file"**
   - File name: `data-deletion-instructions.html`
   - Copy the content from: `web/data-deletion-instructions.html` in your project
   - Or use the same content we created earlier
   - Click **"Commit new file"**

---

## 📋 **Step 4: Enable GitHub Pages**

1. In your repository, click **"Settings"** (top menu)

2. Scroll down to **"Pages"** in the left sidebar

3. Under **"Source"**, select:
   - **Branch**: `main` (or `master` if that's your default branch)
   - **Folder**: `/ (root)`
   - Click **"Save"**

4. Wait 1-2 minutes for GitHub to build your site

5. You'll see a message: **"Your site is published at..."**
   - Your URL will be: `https://YOUR_USERNAME.github.io/robocleaner-website/`
   - Example: `https://johndoe.github.io/robocleaner-website/`

---

## 📋 **Step 5: Verify Your Website Works**

1. Visit your GitHub Pages URL:
   ```
   https://YOUR_USERNAME.github.io/robocleaner-website/
   ```

2. You should see your homepage

3. Test the links:
   - `https://YOUR_USERNAME.github.io/robocleaner-website/privacy-policy.html`
   - `https://YOUR_USERNAME.github.io/robocleaner-website/data-deletion-instructions.html`

---

## 📋 **Step 6: Use in Facebook**

1. Go back to Facebook Developer Console
2. In the "Website" field, enter:
   ```
   https://YOUR_USERNAME.github.io/robocleaner-website/
   ```
3. Click **"Next"**
4. Facebook should now accept this URL! ✅

---

## 🔄 **Option B: Upload Files Using Git (Advanced)**

If you prefer using Git commands:

### Step 1: Initialize Git (if not already done)

```powershell
cd C:\Users\ASUS\robocleaner
git init
```

### Step 2: Copy Files to a New Folder

```powershell
# Create a folder for GitHub Pages
mkdir github-pages
copy web\privacy-policy.html github-pages\
copy web\data-deletion-instructions.html github-pages\
```

### Step 3: Create index.html

Create `github-pages\index.html` with the content from Step 3 above.

### Step 4: Add Remote and Push

```powershell
cd github-pages
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/robocleaner-website.git
git push -u origin main
```

---

## ✅ **Quick Checklist**

- [ ] Created GitHub account
- [ ] Created new public repository
- [ ] Created `index.html` file
- [ ] Created `privacy-policy.html` file
- [ ] Created `data-deletion-instructions.html` file
- [ ] Enabled GitHub Pages in Settings
- [ ] Verified website is accessible
- [ ] Copied GitHub Pages URL
- [ ] Used URL in Facebook Developer Console

---

## 🎯 **Your Final URLs**

After setup, you'll have:

- **Homepage**: `https://YOUR_USERNAME.github.io/robocleaner-website/`
- **Privacy Policy**: `https://YOUR_USERNAME.github.io/robocleaner-website/privacy-policy.html`
- **Data Deletion**: `https://YOUR_USERNAME.github.io/robocleaner-website/data-deletion-instructions.html`

---

## 📝 **Update Your App's Privacy Policy Links**

After setting up GitHub Pages, you may want to update your app to use these URLs instead of Firebase URLs:

1. Update `web/privacy-policy.html` links
2. Update `web/data-deletion-instructions.html` links
3. Or keep both URLs working (both Firebase and GitHub Pages)

---

## 🆘 **Troubleshooting**

### Problem: "404 Not Found" after enabling Pages

**Solution:**
- Wait 2-5 minutes for GitHub to build
- Make sure your files are in the `main` branch
- Check that `index.html` exists in the root

### Problem: "Repository not found"

**Solution:**
- Make sure repository is **Public** (not Private)
- Free GitHub accounts require public repos for Pages

### Problem: Files not showing

**Solution:**
- Make sure you committed the files
- Check that file names are correct (case-sensitive)
- Clear browser cache

### Problem: Facebook still rejects the URL

**Solution:**
- Make sure URL starts with `https://`
- Wait a few minutes after creating the site
- Try accessing the URL in an incognito browser first
- Make sure the site is publicly accessible

---

## 🎉 **Success!**

Once your GitHub Pages site is live, you can use that URL in Facebook Developer Console. Facebook will accept it because it's a custom domain (not a generic hosting service like Firebase's default domain).

**Your website URL for Facebook:**
```
https://YOUR_USERNAME.github.io/robocleaner-website/
```

Replace `YOUR_USERNAME` with your actual GitHub username!

---

## 📞 **Need Help?**

If you encounter any issues:
1. Check GitHub Pages documentation: https://docs.github.com/en/pages
2. Verify your repository is public
3. Make sure all files are committed
4. Wait a few minutes for GitHub to build the site

Good luck! 🚀

