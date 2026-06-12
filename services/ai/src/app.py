from fastapi import FastAPI

app = FastAPI(title="Vexora AI Service")

@app.get("/health")
def health():
    return {"status": "ok", "service": "ai-service"}

@app.get("/version")
def version():
    return {"service": "ai", "status": "ready"}
