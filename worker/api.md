•  基础路径：你的 Worker 域名（例如 https://your-worker.example.workers.dev）
•  认证方式：HTTP Header 携带 Authorization: Bearer {AUTH_SECRET_KEY}
•  内容类型：请求体使用 Content-Type: application/json
•  CORS：已允许任意来源与头部（authorization, content-type）

数据模型
•  Note
•  id: string
•  content: string
•  createdAt: string（ISO 8601，服务器返回时转换自毫秒时间戳）

通用响应
•  成功：JSON 对象或数组
•  失败：{ "error": string }
•  常见状态码：200 OK、201 Created、400 Bad Request、401 Unauthorized、404 Not Found、500 Internal Error

健康检查与鉴权
•  GET /health
•  无需鉴权
•  响应：{ ok: true }
•  GET /auth
•  需要鉴权
•  200: { ok: true }
•  401: { ok: false, error: "Unauthorized" }

笔记相关接口

1) 获取所有笔记（包含空内容）
•  GET /notes
•  认证：需要
•  请求体：无
•  响应：200
•  [
      { "id": "note-1", "content": "hello", "createdAt": "2025-08-15T01:10:00.000Z" },
      { "id": "note-2", "content": "", "createdAt": "2025-08-15T01:09:00.000Z" }
    ]
•  说明：返回所有笔记，按 createdAt 降序；包含 content 为空字符串的记录

2) 获取单条笔记
•  GET /getNote/:id
•  认证：需要
•  请求体：无
•  响应：
•  200: { "id": "note-1", "content": "hello", "createdAt": "2025-08-15T01:10:00.000Z" }
•  404: { "error": "Note not found" }

3) 保存笔记（新建或更新）
•  POST /saveNote
•  认证：需要
•  请求体：
•  { "id": "note-1", "content": "new content" }
•  行为：
•  若 id 不存在：插入新纪录
•  若 id 已存在：更新 content，并刷新时间戳
•  响应：
•  200: 返回保存后的完整记录
◦  { "id": "note-1", "content": "new content", "createdAt": "2025-08-15T01:11:00.000Z" }
•  400: { "error": "Missing or invalid id|content" }
•  401: { "error": "Unauthorized" }
•  500: { "error": "Internal error" }

4) 删除笔记（保留键，仅清空内容）
•  DELETE /deleteNote/:id
•  认证：需要
•  行为：不删除记录，只将 content 置为 ""，并刷新时间戳
•  响应：
•  200: { "id": "note-1", "content": "", "createdAt": "2025-08-15T01:12:00.000Z" }
•  404: { "error": "Note not found" }

请求示例（curl）
•  获取所有
•  curl -X GET {{BASE_URL}}/notes -H "Authorization: Bearer {{AUTH_SECRET_KEY}}"
•  获取单条
•  curl -X GET {{BASE_URL}}/getNote/note-1 -H "Authorization: Bearer {{AUTH_SECRET_KEY}}"
•  保存（新建或更新）
•  curl -X POST {{BASE_URL}}/saveNote -H "Authorization: Bearer {{AUTH_SECRET_KEY}}" -H "Content-Type: application/json" -d "{"id":"note-1","content":"hello"}"
•  逻辑删除（清空内容）
•  curl -X DELETE {{BASE_URL}}/deleteNote/note-1 -H "Authorization: Bearer {{AUTH_SECRET_KEY}}"

备注
•  createdAt 字段当前用于排序与更新时间记录，保存与“删除”（清空）时都会更新
•  当 content 被清空后，该记录依然会出现在 /notes 列表中
•  若未来需要真正物理删除，可新增专用接口以避免与当前逻辑冲突