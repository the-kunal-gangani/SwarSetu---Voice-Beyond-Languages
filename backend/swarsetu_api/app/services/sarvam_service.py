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
        
        result = response.json()
        print(f"\n--- DEBUG SAARAS (STT) RESPONSE ---\n{result}\n")
        return result.get("transcript", "")

async def translate_text(text: str, source_lang: str, target_lang: str) -> str:
    """Sarvam Mayura Translation"""
    if not settings.SARVAM_API_KEY:
        # Mock response if API key is not yet set
        return f"[Translated to {target_lang}]: {text}"

    url = f"{settings.SARVAM_BASE_URL}/translate"
    
    # Format language codes to match Sarvam's expected "-IN" suffix
    src_code = f"{source_lang}-IN" if "-" not in source_lang and source_lang != "auto" else source_lang
    tgt_code = f"{target_lang}-IN" if "-" not in target_lang else target_lang
    
    # "input" must be a string, not a list
    payload = {
        "input": text,  
        "source_language_code": src_code,
        "target_language_code": tgt_code,
        "mode": "formal",
        "model": "mayura:v1"
    }

    async with httpx.AsyncClient() as client:
        headers = {**HEADERS, "Content-Type": "application/json"}
        response = await client.post(url, headers=headers, json=payload, timeout=15.0)
        
        if response.status_code != 200:
            raise HTTPException(status_code=response.status_code, detail=f"Translation Error: {response.text}")
        
        result = response.json()
        print(f"\n--- DEBUG MAYURA (TRANS) RESPONSE ---\n{result}\n")
        return result.get("translated_text", "")

async def text_to_speech(text: str, target_lang: str) -> bytes:
    """Sarvam Bulbul TTS"""
    if not settings.SARVAM_API_KEY:
        # Mock response returning empty bytes if API key is not yet set
        return b"mock_audio_bytes"

    url = f"{settings.SARVAM_BASE_URL}/text-to-speech"
    
    # Format language codes to match Sarvam's expected "-IN" suffix
    tgt_code = f"{target_lang}-IN" if "-" not in target_lang else target_lang

    payload = {
        "inputs": [text],
        "target_language_code": tgt_code,
        "model": "bulbul:v3",
        "speaker": "shubh"
    }

    async with httpx.AsyncClient() as client:
        headers = {**HEADERS, "Content-Type": "application/json"}
        response = await client.post(url, headers=headers, json=payload, timeout=30.0)
        
        if response.status_code != 200:
            raise HTTPException(status_code=response.status_code, detail=f"TTS Error: {response.text}")
        
        result = response.json()
        print(f"\n--- DEBUG BULBUL (TTS) RESPONSE ---\n{result.keys()}\n")
        
        audios = result.get("audios", [])
        if audios:
            return base64.b64decode(audios[0])
            
        raise HTTPException(status_code=500, detail="No audio returned from TTS")