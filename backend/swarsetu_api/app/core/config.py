import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    PROJECT_NAME: str = "SwarSetu API"
    SARVAM_API_KEY: str = os.getenv("SARVAM_API_KEY", "")
    SARVAM_BASE_URL: str = "https://api.sarvam.ai"
    FIREBASE_STORAGE_BUCKET: str = os.getenv("FIREBASE_STORAGE_BUCKET", "")

settings = Settings()