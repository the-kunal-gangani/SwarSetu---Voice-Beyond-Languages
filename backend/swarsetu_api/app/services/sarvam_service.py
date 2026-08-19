import httpx
import base64
from fastapi import HTTPException
from app.core.config import settings

HEADERS = {"api-subscription-key": settings.SARVAM_API_KEY}

async def speech_to_text(audio_bytes: bytes, filename: str = "audio.wav") -> str:
    """Sarvam Saaras STT"""
    if not settings.SARVAM_API_KEY:
        # Mock response if API key is not yet set
        return "Mock transcribed text"
        
    url = f"{settings.SARVAM_BASE_URL}/speech-to-text"
    files = {"file": (filename, audio_bytes, "audio/wav")}
    data = {"model": "saaras:v3", "mode": "transcribe"}

    async with httpx.AsyncClient() as client:
        response = await client.post(url, headers=HEADERS, files=files, data=data, timeout=30.0)
        if response.status_code != 200:
            raise HTTPException(status_code=response.status_code, detail=f"STT Error: {response.text}")
        return response.json().get("transcript", "")

async def translate_text(text: str, source_lang: str, target_lang: str) -> str:
    """Sarvam Mayura Translation"""
    if not settings.SARVAM_API_KEY:
        # Mock response if API key is not yet set
        return f"[Translated to {target_lang}]: {text}"

    url = f"{settings.SARVAM_BASE_URL}/translate"
    payload = {
        "input": [text],
        "source_language_code": source_lang,
        "target_language_code": target_lang,
        "mode": "formal",
        "model": "mayura:v1"
    }

    async with httpx.AsyncClient() as client:
        headers = {**HEADERS, "Content-Type": "application/json"}
        response = await client.post(url, headers=headers, json=payload, timeout=15.0)
        if response.status_code != 200:
            raise HTTPException(status_code=response.status_code, detail=f"Translation Error: {response.text}")
        translations = response.json().get("translations", [])
        return translations[0] if translations else ""

async def text_to_speech(text: str, target_lang: str) -> bytes:
    """Sarvam Bulbul TTS"""
    if not settings.SARVAM_API_KEY:
        return b"mock_audio_bytes"

    url = f"{settings.SARVAM_BASE_URL}/text-to-speech"
    payload = {
        "inputs": [text],
        "target_language_code": target_lang,
        "model": "bulbul:v3",
        "speaker": "shubh"
    }

    async with httpx.AsyncClient() as client:
        headers = {**HEADERS, "Content-Type": "application/json"}
        response = await client.post(url, headers=headers, json=payload, timeout=30.0)
        if response.status_code != 200:
            raise HTTPException(status_code=response.status_code, detail=f"TTS Error: {response.text}")
        
        audios = response.json().get("audios", [])
        if audios:
            return base64.b64decode(audios[0])
        raise HTTPException(status_code=500, detail="No audio returned from TTS")