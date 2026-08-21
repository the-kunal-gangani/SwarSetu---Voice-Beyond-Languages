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
    async def process_audio_translation(audio_bytes: bytes, filename: str, source_lang: str, target_lang: str) -> TranslationResponse:
        # 1. STT
        source_text = await sarvam_service.speech_to_text(audio_bytes, filename)
        # 2. Translation
        translated_text = await sarvam_service.translate_text(source_text, source_lang, target_lang)
        # 3. TTS
        tts_audio = await sarvam_service.text_to_speech(translated_text, target_lang)
        
        # 4. Save audio locally for immediate streaming
        audio_filename = f"{uuid.uuid4()}.wav"
        filepath = os.path.join("local_audio", audio_filename)
        with open(filepath, "wb") as f:
            f.write(tts_audio)
            
        audio_url = f"http://10.0.2.2:8000/static/{audio_filename}"  # 10.0.2.2 maps to host from Android emulator

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