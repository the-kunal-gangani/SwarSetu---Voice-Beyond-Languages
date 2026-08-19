from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class TranslationTextRequest(BaseModel):
    text: str
    source_language: str
    target_language: str

class TranslationResponse(BaseModel):
    id: str
    source_language: str
    target_language: str
    source_text: str
    translated_text: str
    audio_url: Optional[str] = None
    timestamp: str