-- D1 migration: create notes table
-- Run with `wrangler d1 migrations apply` or during first deploy.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS notes (
  id TEXT PRIMARY KEY,
  content TEXT NOT NULL,
  createdAt INTEGER NOT NULL
);

-- Helpful index for createdAt ordering
CREATE INDEX IF NOT EXISTS idx_notes_createdAt ON notes(createdAt DESC);

