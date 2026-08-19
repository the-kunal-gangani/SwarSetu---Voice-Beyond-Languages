import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from app.api.router import api_router

app = FastAPI(title="SwarSetu API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

os.makedirs("local_audio", exist_ok=True)
app.mount("/static", StaticFiles(directory="local_audio"), name="static")

app.include_router(api_router)

@app.get("/health")
def health():
    return {"status": "ok"}