-- ─────────────────────────────────────────────────────────────────────────────
-- InOutZen Employee QR Attendance & Work Report System — Supabase SQL Schema
-- ─────────────────────────────────────────────────────────────────────────────
-- Execute this SQL script in your Supabase SQL Editor to create all required
-- tables, indexes, and Row Level Security (RLS) policies for Netlify deployment.

-- 1. Employees Table
CREATE TABLE IF NOT EXISTS public.employees (
    id TEXT PRIMARY KEY,
    employee_code TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    department TEXT NOT NULL,
    designation TEXT NOT NULL,
    joining_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    qr_token TEXT UNIQUE NOT NULL,
    qr_code_url TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Working Days Table
CREATE TABLE IF NOT EXISTS public.working_days (
    id TEXT PRIMARY KEY,
    date DATE UNIQUE NOT NULL,
    is_working_day BOOLEAN NOT NULL DEFAULT TRUE,
    allowed_time TEXT DEFAULT '10:15 AM',
    reason TEXT,
    created_by TEXT DEFAULT 'Admin',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Attendance Records Table
CREATE TABLE IF NOT EXISTS public.attendance_records (
    id TEXT PRIMARY KEY,
    employee_id TEXT NOT NULL REFERENCES public.employees(id) ON DELETE CASCADE,
    attendance_date DATE NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('Present', 'Late', 'Half Day', 'Work From Home', 'WFH', 'Leave', 'Other', 'Absent')),
    check_in_time TEXT NOT NULL DEFAULT '-',
    allowed_time TEXT,
    is_late BOOLEAN DEFAULT FALSE,
    late_minutes INT DEFAULT 0,
    source TEXT DEFAULT 'Admin' CHECK (source IN ('QR Scan', 'Admin', 'System')),
    notes TEXT,
    modified_by TEXT DEFAULT 'Admin',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (employee_id, attendance_date)
);

-- 4. Work Reports Table
CREATE TABLE IF NOT EXISTS public.work_reports (
    id TEXT PRIMARY KEY,
    employee_id TEXT NOT NULL REFERENCES public.employees(id) ON DELETE CASCADE,
    report_date DATE NOT NULL,
    tasks_completed TEXT NOT NULL,
    hours_worked NUMERIC(4, 2) NOT NULL DEFAULT 8.0,
    status TEXT NOT NULL DEFAULT 'Submitted' CHECK (status IN ('Submitted', 'Draft', 'Approved')),
    submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (employee_id, report_date)
);

-- 5. System Settings Table
CREATE TABLE IF NOT EXISTS public.system_settings (
    id TEXT PRIMARY KEY DEFAULT 'global',
    allowed_attendance_time TEXT NOT NULL DEFAULT '10:15 AM',
    company_name TEXT NOT NULL DEFAULT 'InOutZen Digital Solutions',
    voice_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    sound_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    auto_reset_seconds INT NOT NULL DEFAULT 5,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for lightning fast queries
CREATE INDEX IF NOT EXISTS idx_attendance_date ON public.attendance_records(attendance_date);
CREATE INDEX IF NOT EXISTS idx_attendance_employee ON public.attendance_records(employee_id);
CREATE INDEX IF NOT EXISTS idx_work_reports_date ON public.work_reports(report_date);
CREATE INDEX IF NOT EXISTS idx_work_reports_employee ON public.work_reports(employee_id);

-- Enable Row Level Security (RLS)
ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.working_days ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.work_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.system_settings ENABLE ROW LEVEL SECURITY;

-- Allow public read/write access for API key requests (enables smooth client operations)
CREATE POLICY "Allow anon read employees" ON public.employees FOR SELECT USING (true);
CREATE POLICY "Allow anon insert employees" ON public.employees FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon update employees" ON public.employees FOR UPDATE USING (true);

CREATE POLICY "Allow anon read working_days" ON public.working_days FOR SELECT USING (true);
CREATE POLICY "Allow anon write working_days" ON public.working_days FOR ALL USING (true);

CREATE POLICY "Allow anon read attendance_records" ON public.attendance_records FOR SELECT USING (true);
CREATE POLICY "Allow anon write attendance_records" ON public.attendance_records FOR ALL USING (true);

CREATE POLICY "Allow anon read work_reports" ON public.work_reports FOR SELECT USING (true);
CREATE POLICY "Allow anon write work_reports" ON public.work_reports FOR ALL USING (true);

CREATE POLICY "Allow anon system_settings" ON public.system_settings FOR ALL USING (true);
