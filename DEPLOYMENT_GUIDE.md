# 🚀 Deployment Guide: InOutZen Attendance & Work Report System

This guide provides complete step-by-step instructions to set up **Supabase** database management and deploy your application to **Netlify** or **Vercel**.

---

## Phase 1: Set Up Supabase Database

1. **Create a Supabase Account & Project**:
   - Go to [https://supabase.com](https://supabase.com) and sign in.
   - Click **"New Project"**, name it `inoutzen-attendance`, and choose a database password.

2. **Run the Database Schema SQL**:
   - In your Supabase Dashboard left menu, click **"SQL Editor"**.
   - Click **"New Query"**.
   - Copy the entire contents of [`supabase_schema.sql`](./supabase_schema.sql) from your project repository and paste it into the query editor.
   - Click **"Run"** (or press Ctrl + Enter).
   - *Verification:* Go to **Table Editor** on the left menu. You should see tables: `employees`, `working_days`, `attendance_records`, `work_reports`, `system_settings`.

3. **Get Your Supabase Credentials**:
   - Go to **Project Settings** (gear icon) → **API**.
   - Copy the following values:
     - **Project URL** (e.g., `https://xyzcompany.supabase.co`)
     - **anon / public key** (e.g., `eyJhbGciOiJIUzI1NiIsIn...`)

---

## Phase 2: Deploy to Netlify

### Option A: Via GitHub (Recommended)
1. **Push your project to GitHub**:
   ```bash
   git init
   git add .
   git commit -m "Initial commit for InOutZen System"
   git remote add origin <your-github-repo-url>
   git push -u origin main
   ```

2. **Import Project to Netlify**:
   - Log in to [https://app.netlify.com](https://app.netlify.com).
   - Click **"Add new site"** → **"Import an existing project"**.
   - Select **GitHub** and pick your repository.

3. **Configure Build Settings**:
   - **Build Command:** `npm run build`
   - **Publish directory:** `dist`

4. **Add Environment Variables**:
   - In Netlify build settings, click **"Environment variables"** → **"Add a variable"**:
     - `VITE_SUPABASE_URL` = `<your-supabase-project-url>`
     - `VITE_SUPABASE_ANON_KEY` = `<your-supabase-anon-key>`

5. **SPA Redirect Rules (Fix 404s on Refresh)**:
   - Ensure a file named `public/_redirects` exists with:
     ```text
     /*    /index.html   200
     ```

6. Click **"Deploy Site"**. Netlify will build and deploy your app live!

---

## Phase 3: Deploy to Vercel

### Option A: Via GitHub / Vercel Dashboard
1. Log in to [https://vercel.com](https://vercel.com).
2. Click **"Add New..."** → **"Project"**.
3. Select your GitHub repository.
4. **Framework Preset:** Vite (Auto-detected).
5. **Build and Output Settings**:
   - Build Command: `npm run build`
   - Output Directory: `dist`
6. **Environment Variables**:
   - Add Variable:
     - Key: `VITE_SUPABASE_URL` | Value: `<your-supabase-project-url>`
     - Key: `VITE_SUPABASE_ANON_KEY` | Value: `<your-supabase-anon-key>`
7. Click **"Deploy"**.

### SPA Rewrites for Vercel (`vercel.json`)
Ensure a `vercel.json` file is in your root directory:
```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

---

## Phase 4: Local Build & Testing Before Deployment

To test the production build on your computer prior to deploying:

```bash
# 1. Build the production bundle
npm run build

# 2. Preview the production build locally
npm run preview
```

---

## 🔑 Login Credentials Reference

- **Admin Login:**
  - Role: `Admin`
  - Username: `admin`
  - Password: `admin123`
- **Employee Login:**
  - Role: `Employee`
  - Employee Code: `EMP-001` (or employee email/phone)
  - Passcode / PIN: `123456`
