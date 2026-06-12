# Vexora API Contract Document

## 1. Gateway API (Node.js)

### `GET /health`
- **Description:** Basic service liveness check.
- **Response:**
```json
{
  "status": "ok",
  "service": "backend"
}
```

### `GET /version`
- **Description:** Returns the deployed version from package.json.
- **Response:**
```json
{
  "service": "backend",
  "version": "0.1.0"
}
```

### `POST /v1/jobs/intelligence` (Planned)
- **Description:** Submit a video for AI metadata extraction.
- **Request Body:**
```json
{
  "assetId": "uuid-1234",
  "assetUrl": "s3://vexora-bucket/proxies/video_1.mp4",
  "tasks": ["scene", "beat", "speech"]
}
```
- **Response:**
```json
{
  "jobId": "job-9999",
  "status": "queued",
  "estimatedTimeSec": 15
}
```

### `POST /v1/styles/extract` (Planned)
- **Description:** Publish a finished edit to extract its Style DNA.
- **Request Body:**
```json
{
  "projectId": "uuid-4321",
  "projectSchema": { "...": "..." },
  "intelligenceReport": { "...": "..." }
}
```
- **Response:**
```json
{
  "styleId": "fitness_alex_v1",
  "dna": { "...": "..." }
}
```

---

## 2. AI Intelligence Service (Python)

### `GET /health`
- **Description:** Basic service liveness check.
- **Response:**
```json
{
  "status": "ok",
  "service": "ai-service"
}
```

### `POST /ai/v1/analyze` (Planned)
- **Description:** Internal endpoint for extracting video metadata synchronously.
- **Request Body:**
```json
{
  "videoUrl": "s3://vexora-bucket/proxies/video_1.mp4"
}
```
- **Response:**
```json
{
  "videoId": "uuid-1234",
  "scenes": [ { "sceneStart": 0, "sceneEnd": 4500 } ],
  "beats": [ { "beatTimestamp": 5200 } ],
  "speech": [],
  "faces": [],
  "highlights": []
}
```

### `POST /ai/v1/director` (Planned)
- **Description:** Internal endpoint to translate intent into a concrete Edit Blueprint.
- **Request Body:**
```json
{
  "intent": { "prompt": "Make it hype", "keywords": ["gym"] },
  "projectSchema": { "...": "..." },
  "styleDna": { "...": "..." }
}
```
- **Response:**
```json
{
  "blueprintVersion": "1.0",
  "blueprintId": "uuid-8888",
  "overallConfidenceScore": 0.92,
  "operations": {
    "cuts": [],
    "transitions": [],
    "zooms": [],
    "captions": [],
    "audio": []
  }
}
```
