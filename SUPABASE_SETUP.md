# Supabase Setup Guide for Profile Image Upload

## 📋 Prerequisites

1. Create a Supabase account at https://supabase.com
2. Create a new project in Supabase

## 🔧 Setup Steps

### 1. Get Your Supabase Credentials

1. Go to your Supabase project dashboard
2. Navigate to **Settings** → **API**
3. Copy the following:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon/public key** (the `anon` key, not the `service_role` key)

### 2. Update main.dart

Open `lib/main.dart` and replace the placeholder values:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL', // Replace with your actual Supabase URL
  anonKey: 'YOUR_SUPABASE_ANON_KEY', // Replace with your actual anon key
);
```

### 3. Create Storage Bucket in Supabase

1. Go to **Storage** in your Supabase dashboard
2. Click **New bucket**
3. Create a bucket named: `profile-images`
4. Set the bucket to **Public** (so images can be accessed via URL)
5. Click **Create bucket**

### 4. Set Up Storage Policies

**Important:** Since you're using Firebase Auth (not Supabase Auth), you need to configure the storage bucket to allow public uploads or disable RLS.

#### Option A: Disable RLS (Recommended for Public Bucket)

1. Go to **Storage** in your Supabase dashboard
2. Click on the `profile-images` bucket
3. Go to **Settings** (gear icon) or **Policies** tab
4. Find **"Row Level Security (RLS)"** toggle
5. **Turn OFF RLS** (disable it)
6. Click **Save**

This allows anyone to upload/update/delete files in the bucket. Since the bucket is public anyway, this is acceptable for profile images.

#### Option B: Allow Public Access with Policies (Alternative)

If you prefer to keep RLS enabled, create these policies:

1. Go to **Storage** → **Policies** for the `profile-images` bucket
2. Click **"New Policy"** or **"Create Policy"**

**Policy 1: Allow public uploads**
- **Policy Name:** `Allow public uploads`
- **Allowed operation:** INSERT
- **Policy definition:**
```sql
bucket_id = 'profile-images'
```
- **Check "Allow public access"** or use: `true` as the condition

**Policy 2: Allow public updates**
- **Policy Name:** `Allow public updates`
- **Allowed operation:** UPDATE
- **Policy definition:**
```sql
bucket_id = 'profile-images'
```

**Policy 3: Allow public deletes**
- **Policy Name:** `Allow public deletes`
- **Allowed operation:** DELETE
- **Policy definition:**
```sql
bucket_id = 'profile-images'
```

**Policy 4: Allow public reads (if not already enabled)**
- **Policy Name:** `Allow public reads`
- **Allowed operation:** SELECT
- **Policy definition:**
```sql
bucket_id = 'profile-images'
```

**Note:** Option A (disabling RLS) is simpler and recommended since your bucket is already public.

### 5. Create Folder Structure

In Supabase Storage, **folders are created automatically** when you upload files to a path that includes a folder name. However, you can also create them manually for better organization.

#### Option A: Automatic Creation (Recommended)
Folders will be created automatically when the first image is uploaded. No manual setup needed!

#### Option B: Manual Creation (Optional - for organization)

**Step-by-step to manually create folders:**

1. **Go to Storage in Supabase Dashboard**
   - Open your Supabase project
   - Click on **Storage** in the left sidebar

2. **Select the `profile-images` bucket**
   - Click on the `profile-images` bucket you created earlier

3. **Create the first folder: `user-profiles`**
   - Click the **"New folder"** button (or **"Create folder"**)
   - Enter folder name: `user-profiles`
   - Click **"Create"** or **"Save"**

4. **Create the second folder: `admin-profiles`**
   - Click **"New folder"** again
   - Enter folder name: `admin-profiles`
   - Click **"Create"** or **"Save"**

5. **Verify folder structure**
   - You should now see:
     ```
     profile-images/
     ├── user-profiles/
     └── admin-profiles/
     ```

**Alternative Method (Using File Upload):**
If you don't see a "New folder" button, you can create folders by uploading a dummy file:

1. Click **"Upload file"** in the `profile-images` bucket
2. Upload any small image file (or create a `.gitkeep` file)
3. When naming the file, use: `user-profiles/.gitkeep`
4. This will automatically create the `user-profiles` folder
5. Repeat for `admin-profiles/.gitkeep`

**Note:** You can delete the `.gitkeep` files after the folders are created - they're just placeholders.

#### Folder Structure Details

The service automatically organizes files in this structure:
- **`user-profiles/`** - Contains profile images for regular users
- **`admin-profiles/`** - Contains profile images for admin users

**File naming pattern:** `{folder}/{userId}{timestamp}.{extension}`

**Example:**
- User ID: `abc123def456`
- Upload time: January 1, 2025 (timestamp: `1735123456789`)
- File type: JPEG
- **Result:** `user-profiles/abc123def4561735123456789.jpg`

**Important Notes:**
- Folders are created automatically when the first file is uploaded to that path
- Each upload creates a new file with a unique timestamp
- The `upsert: true` option in the code ensures files with the same name are replaced
- File paths are case-sensitive

## 🔐 Security Notes

- The bucket is set to **Public** so profile images can be accessed via URL
- Users can only upload/update/delete their own images
- Image size is limited to 5MB
- Only JPG, PNG, and WebP formats are allowed

## ✅ Testing

1. Run `flutter pub get` to install dependencies
2. Update `main.dart` with your Supabase credentials
3. Run the app and test uploading a profile image
4. Check Supabase Storage to verify the image was uploaded

## 🐛 Troubleshooting

### Error: "Invalid API key"
- Make sure you're using the `anon` key, not the `service_role` key
- Verify the key is copied correctly (no extra spaces)

### Error: "Bucket not found"
- Make sure the bucket is named exactly `profile-images`
- Check that the bucket is set to Public

### Error: "Permission denied" or "Row-level security policy violation"
- **Solution 1 (Recommended):** Disable RLS on the `profile-images` bucket
  - Go to Storage → `profile-images` bucket → Settings
  - Turn OFF "Row Level Security (RLS)"
  - Save changes
- **Solution 2:** Create public access policies (see Option B in Step 4)
- **Solution 3:** If using Supabase Auth, make sure the user is authenticated with Supabase (not just Firebase)

### Images not showing
- Check that the bucket is set to Public
- Verify the photoUrl is being saved correctly in Firestore
- Check browser console for CORS errors

## 📝 Additional Configuration

### For Production

Consider:
1. Setting up image optimization/compression
2. Adding CDN for faster image delivery
3. Implementing image caching
4. Adding rate limiting for uploads

