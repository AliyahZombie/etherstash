// Cloudflare Worker implementing simple Bearer-token auth and CRUD for notes in D1
// No external dependencies.

/**
 * Expected environment bindings:
 * - AUTH_SECRET_KEY (secret): string Bearer token used for authenticating requests
 * - DB (D1Database): Cloudflare D1 binding
 */

/** @typedef {{ AUTH_SECRET_KEY: string, DB: D1Database }} Env */

/**
 * @typedef Note
 * @property {string} id
 * @property {string} content
 * @property {number} createdAt
 * @property {number} updatedAt
 */

/** Utility: JSON response with common headers (incl. CORS) */
function json(data, init = {}) {
  const body = JSON.stringify(data);
  const headers = new Headers(init.headers || {});
  if (!headers.has('content-type')) headers.set('content-type', 'application/json; charset=utf-8');
  // CORS: allow all origins by default; adjust if needed
  if (!headers.has('access-control-allow-origin')) headers.set('access-control-allow-origin', '*');
  headers.set('access-control-allow-headers', 'authorization, content-type');
  headers.set('access-control-allow-methods', 'GET,POST,PUT,DELETE,OPTIONS');
  return new Response(body, { ...init, headers });
}

function text(body, init = {}) {
  const headers = new Headers(init.headers || {});
  if (!headers.has('content-type')) headers.set('content-type', 'text/plain; charset=utf-8');
  if (!headers.has('access-control-allow-origin')) headers.set('access-control-allow-origin', '*');
  headers.set('access-control-allow-headers', 'authorization, content-type');
  headers.set('access-control-allow-methods', 'GET,POST,PUT,DELETE,OPTIONS');
  return new Response(body, { ...init, headers });
}

/** Extract Bearer token from Authorization header */
function getBearerToken(req) {
  const auth = req.headers.get('authorization') || req.headers.get('Authorization');
  if (!auth) return null;
  const [type, token] = auth.split(' ');
  if (!type || !token) return null;
  if (type.toLowerCase() !== 'bearer') return null;
  return token.trim();
}

/** Simple auth check: compare header token with env secret */
function hasAuthConfigured(env) {
  return typeof env.AUTH_SECRET_KEY === 'string' && env.AUTH_SECRET_KEY.length > 0;
}
function hasDbBound(env) {
  return env && env.DB && typeof env.DB.prepare === 'function';
}
function isAuthorized(req, env) {
  if (!hasAuthConfigured(env)) return false;
  const token = getBearerToken(req);
  if (!token) return false;
  return token === env.AUTH_SECRET_KEY;
}

/** Parse JSON body safely */
async function readJson(req) {
  try {
    return await req.json();
  } catch {
    return null;
  }
}

/** Route matching helpers */
function match(pathname, pattern) {
  // pattern like '/notes' or '/notes/:id'
  const pSegs = pattern.split('/').filter(Boolean);
  const uSegs = pathname.split('/').filter(Boolean);
  if (pSegs.length !== uSegs.length) return null;
  const params = {};
  for (let i = 0; i < pSegs.length; i++) {
    const p = pSegs[i];
    const u = uSegs[i];
    if (p.startsWith(':')) {
      params[p.slice(1)] = decodeURIComponent(u);
    } else if (p !== u) {
      return null;
    }
  }
  return params;
}

async function ensureSchema(env) {
  // Ensure the notes table exists to avoid runtime errors when migrations weren't applied yet
  try {
    await env.DB.prepare(
      'CREATE TABLE IF NOT EXISTS notes (id TEXT PRIMARY KEY, content TEXT NOT NULL, createdAt INTEGER NOT NULL)'
    ).run();
    await env.DB.prepare(
      'CREATE INDEX IF NOT EXISTS idx_notes_createdAt ON notes(createdAt DESC)'
    ).run();
  } catch (e) {
    console.error('ensureSchema failed:', e && e.message ? e.message : e);
    throw e;
  }
}

async function handleGetNotes(env) {
  await ensureSchema(env);
  const { results } = await env.DB.prepare(
    'SELECT id, content, createdAt FROM notes ORDER BY createdAt DESC'
  ).all();
  const data = (results || []).map((r) => ({
    id: r.id,
    content: r.content,
    createdAt: new Date(Number(r.createdAt)).toISOString(),
  }));
  return json(data);
}

async function handleGetNote(env, params) {
  await ensureSchema(env);
  const noteId = params.id;
  if (!noteId) return json({ error: 'Missing id' }, { status: 400 });
  const row = await env.DB.prepare('SELECT id, content, createdAt FROM notes WHERE id = ?')
    .bind(noteId)
    .first();
  if (!row) return json({ error: 'Note not found' }, { status: 404 });
  return json({
    id: row.id,
    content: row.content,
    createdAt: new Date(Number(row.createdAt)).toISOString(),
  });
}

async function handleSaveNote(req, env) {
  await ensureSchema(env);
  /** @type {Partial<Note> | null} */
  const body = await readJson(req);
  if (!body || typeof body !== 'object') {
    return json({ error: 'Invalid JSON body' }, { status: 400 });
  }
  const { id, content } = body;
  if (!id || typeof id !== 'string') {
    return json({ error: 'Missing or invalid id' }, { status: 400 });
  }
  if (typeof content !== 'string') {
    return json({ error: 'Missing or invalid content' }, { status: 400 });
  }
  const now = Date.now();
  try {
    // Upsert: create or update content and timestamp
    await env.DB.prepare(
      'INSERT INTO notes (id, content, createdAt) VALUES (?, ?, ?)\n' +
      'ON CONFLICT(id) DO UPDATE SET content = excluded.content, createdAt = excluded.createdAt'
    ).bind(id, content, now).run();
    const row = await env.DB.prepare('SELECT id, content, createdAt FROM notes WHERE id = ?')
      .bind(id)
      .first();
    return json({
      id: row.id,
      content: row.content,
      createdAt: new Date(Number(row.createdAt)).toISOString(),
    }, { status: 200 });
  } catch (e) {
    if (e && e.message) console.error('Save note failed:', e.message);
    return json({ error: 'Internal error' }, { status: 500 });
  }
}


async function handleDeleteNote(env, params) {
  await ensureSchema(env);
  const noteId = params.id;
  if (!noteId) return json({ error: 'Missing id' }, { status: 400 });
  try {
    const now = Date.now();
    await env.DB.prepare(
      'UPDATE notes SET content = ?, createdAt = ? WHERE id = ?'
    ).bind('', now, noteId).run();

    // 无论 UPDATE 是否有变更，先尝试读取；
    // 若读取不到再 INSERT，避免“本来存在但值未变化”的误判导致的唯一键冲突。
    let row = await env.DB.prepare('SELECT id, content, createdAt FROM notes WHERE id = ?')
      .bind(noteId)
      .first();

    if (!row) {
      await env.DB.prepare(
        'INSERT INTO notes (id, content, createdAt) VALUES (?, ?, ?)'
      ).bind(noteId, '', now).run();
      row = await env.DB.prepare('SELECT id, content, createdAt FROM notes WHERE id = ?')
        .bind(noteId)
        .first();
    }

    return json({
      id: row.id,
      content: row.content,
      createdAt: new Date(Number(row.createdAt)).toISOString(),
    });
  } catch (e) {
    if (e && e.message) console.error('Delete note failed:', e.message);
    return json({ error: 'Internal error' }, { status: 500 });
  }
}

export default {
  /** @param {Request} req @param {Env} env */
  async fetch(req, env) {
    const url = new URL(req.url);

    // CORS preflight should not require auth
    if (req.method === 'OPTIONS') {
      return new Response(null, {
        status: 204,
        headers: {
          'access-control-allow-origin': '*',
          'access-control-allow-headers': 'authorization, content-type',
          'access-control-allow-methods': 'GET,POST,PUT,DELETE,OPTIONS',
          'access-control-max-age': '86400',
        },
      });
    }

    // Health check endpoint without auth (optional)
    if (url.pathname === '/health') {
      return json({ ok: true });
    }

    // Auth check: if not configured, reject everything (except /health)
    if (!hasAuthConfigured(env)) {
      return json({ error: 'Auth not configured' }, { status: 503 });
    }

    // DB binding check early: give a clear error if not bound
    if (!hasDbBound(env)) {
      return json({ error: 'D1 database not bound (missing binding DB)' }, { status: 503 });
    }

    // /auth endpoint: validate Authorization token
    if (req.method === 'GET' && url.pathname === '/auth') {
      if (!isAuthorized(req, env)) {
        return json({ ok: false, error: 'Unauthorized' }, { status: 401 });
      }
      return json({ ok: true });
    }

    // Auth for all other endpoints
    if (!isAuthorized(req, env)) {
      return json({ error: 'Unauthorized' }, { status: 401 });
    }

    // Routing
    if (req.method === 'GET' && match(url.pathname, '/notes')) {
      return handleGetNotes(env);
    }

    if (req.method === 'POST' && match(url.pathname, '/saveNote')) {
      return handleSaveNote(req, env);
    }

    {
      const getParams = match(url.pathname, '/getNote/:id');
      if (req.method === 'GET' && getParams) {
        return handleGetNote(env, getParams);
      }
    }

    {
      const delParams = match(url.pathname, '/deleteNote/:id');
      if (req.method === 'DELETE' && delParams) {
        return handleDeleteNote(env, delParams);
      }
    }

    return text('Not Found', { status: 404 });
  },
};

