-- Example DB bootstrap (tables should be designed later)
CREATE DATABASE vexora_db;
\connect vexora_db;

-- Add schema placeholders
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
