# Quick Fix: Row-Level Security Policy Error

## 🚨 Error Message
```
Failed to upload image: StorageException 
(message: new row violates row-level security policy, 
statusCode: 403, error: Unauthorized)
```

## ✅ Solution: Create Public Access Policies

Since you're using **Firebase Auth** (not Supabase Auth), Supabase doesn't recognize your authentication. You need to create storage policies that allow public access.

### Step-by-Step Fix:

1. **Open Supabase Dashboard**
   - Go to https://app.supabase.com
   - Select your project

2. **Navigate to Storage Policies**
   - Click **"Storage"** in the left sidebar
   - Click on the **`profile-images`** bucket
   - Click on the **"Policies"** tab (or look for "Policies" in the bucket settings)

3. **Create Policy for Uploads (INSERT)**
   - Click **"New Policy"** or **"Create Policy"**
   - **Policy Name:** `Allow public uploads`
   - **Allowed operation:** Select **INSERT**
   - **Policy definition:** Enter `true` (this allows everyone to upload)`
   - Or use this SQL:
   ```sql
   bucket_id = 'profile-images'
   ```
   - Click **"Save"** or **"Create"**

4. **Create Policy for Updates (UPDATE)**
   - Click **"New Policy"** again
   - **Policy Name:** `Allow public updates`
   - **Allowed operation:** Select **UPDATE**
   - **Policy definition:** `true` or `bucket_id = 'profile-images'`
   - Click **"Save"**

5. **Create Policy for Deletes (DELETE)**
   - Click **"New Policy"** again
   - **Policy Name:** `Allow public deletes`
   - **Allowed operation:** Select **DELETE**
   - **Policy definition:** `true` or `bucket_id = 'profile-images'`
   - Click **"Save"**

6. **Create Policy for Reads (SELECT) - if needed**
   - Click **"New Policy"** again
   - **Policy Name:** `Allow public reads`
   - **Allowed operation:** Select **SELECT**
   - **Policy definition:** `true` or `bucket_id = 'profile-images'`
   - Click **"Save"**

7. **Verify**
   - You should now see 4 policies listed
   - Try uploading a profile image again

### Why This Works:

- Your bucket is already set to **Public**, so RLS doesn't add much security
- Since you're using Firebase Auth, Supabase can't verify authentication
- Disabling RLS allows the public bucket to accept uploads
- The app still validates file size and type before upload

### Alternative: If You Want to Keep RLS Enabled

If you prefer to keep RLS enabled, you need to create policies that allow public access:

1. Go to **Storage** → **Policies** for `profile-images`
2. Create these 4 policies with `bucket_id = 'profile-images'` as the condition:
   - **INSERT** policy (for uploads)
   - **UPDATE** policy (for updates)
   - **DELETE** policy (for deletions)
   - **SELECT** policy (for reads)

However, **disabling RLS is recommended** for a public bucket.

## ✅ After Fixing

1. Restart your app
2. Try uploading a profile image again
3. The upload should work now!

## 🔒 Security Note

Since the bucket is public and contains profile images:
- File validation is still enforced (size, type)
- File names include user IDs and timestamps
- Users can only see their own images (via the app logic)
- Consider adding rate limiting in production

