from fastapi import APIRouter, UploadFile, File, Form, HTTPException
from app.schemas.translation_schema import TranslationTextRequest, TranslationResponse
from app.services.translation_service import translation_service

router = APIRouter(prefix="/translation", tags=["Translation"])

@router.post("/text", response_model=TranslationResponse)
async def translate_text_endpoint(payload: TranslationTextRequest):
    return await translation_service.process_text_translation(
        text=payload.text,
        source_lang=payload.source_language,
        target_lang=payload.target_language
    )

@router.post("/audio", response_model=TranslationResponse)
async def translate_audio_endpoint(
    audio: UploadFile = File(...),
    source_language: str = Form(...),
    target_language: str = Form(...)
):
    audio_bytes = await audio.read()
    return await translation_service.process_audio_translation(
        audio_bytes=audio_bytes,
        filename=audio.filename or "audio.wav",
        source_lang=source_language,
        target_lang=target_language
    )