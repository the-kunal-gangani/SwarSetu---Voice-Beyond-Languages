from fastapi import Request
import uuid
import os
from datetime import datetime, timezone
from app.schemas.translation_schema import TranslationResponse
from app.services import sarvam_service

os.makedirs("local_audio", exist_ok=True)

class TranslationService:
    @staticmethod
    async def process_text_translation(text: str, source_lang: str, target_lang: str) -> TranslationResponse:
        translated_text = await sarvam_service.translate_text(text, source_lang, target_lang)
        
        return TranslationResponse(
            id=str(uuid.uuid4()),
            source_language=source_lang,
            target_language=target_lang,
            source_text=text,
            translated_text=translated_text,
            audio_url=None,
            timestamp=datetime.now(timezone.utc).isoformat()
        )

    @staticmethod
    async def process_audio_translation(
        request: Request,  # <-- ADDED
        audio_bytes: bytes, 
        filename: str, 
        source_lang: str, 
        target_lang: str
    ) -> TranslationResponse:
        
        source_text = await sarvam_service.speech_to_text(audio_bytes, filename)
        translated_text = await sarvam_service.translate_text(source_text, source_lang, target_lang)
        tts_audio = await sarvam_service.text_to_speech(translated_text, target_lang)
        
        # Keeping the sync write as advised (it's fast enough for a hackathon MVP)
        audio_filename = f"{uuid.uuid4()}.wav"
        filepath = os.path.join("local_audio", audio_filename)
        with open(filepath, "wb") as f:
            f.write(tts_audio)
            
        # <-- FIX: Dynamic URL generation based on the incoming request
        base_url = str(request.base_url).rstrip("/")
        audio_url = f"{base_url}/static/{audio_filename}" 

        return TranslationResponse(
            id=str(uuid.uuid4()),
            source_language=source_lang,
            target_language=target_lang,
            source_text=source_text,
            translated_text=translated_text,
            audio_url=audio_url,
            timestamp=datetime.now(timezone.utc).isoformat()
        )

translation_service = TranslationService()