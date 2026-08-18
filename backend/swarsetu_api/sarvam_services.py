import os
import httpx
import base64
from dotenv import load_dotenv
from fastapi import HTTPException

# Load environment variables
load_dotenv()

SARVAM_API_KEY = os.getenv("SARVAM_API_KEY")
BASE_URL = "https://api.sarvam.ai"
HEADERS = {"api-subscription-key": SARVAM_API_KEY}

async def speech_to_text(audio_bytes: bytes, filename: str) -> str:
    """
    Transcribes audio to text using Sarvam's Saaras v3 model.
    """
    url = f"{BASE_URL}/speech-to-text"
    
    # Sarvam expects a multipart form containing the file
    files = {
        "file": (filename, audio_bytes, "audio/wav")
    }
    
    # We use 'transcribe' mode for standard transcription
    data = {
        "model": "saaras:v3",
        "mode": "transcribe" 
    }

    async with httpx.AsyncClient() as client:
        response = await client.post(url, headers=HEADERS, files=files, data=data, timeout=30.0)
        
        if response.status_code != 200:
            raise HTTPException(status_code=response.status_code, detail=f"STT Error: {response.text}")
            
        result = response.json()
        return result.get("transcript", "")

async def translate_text(text: str, source_lang: str, target_lang: str) -> str:
    """
    Translates text using Sarvam's Mayura model.
    """
    url = f"{BASE_URL}/translate"
    
    payload = {
        "input": [text],
        "source_language_code": source_lang,
        "target_language_code": target_lang,
        "speaker_gender": "Male",
        "mode": "formal",
        "model": "mayura:v1"
    }

    async with httpx.AsyncClient() as client:
        # Note: Content-Type is application/json for translation
        headers = {**HEADERS, "Content-Type": "application/json"}
        response = await client.post(url, headers=headers, json=payload, timeout=15.0)
        
        if response.status_code != 200:
            raise HTTPException(status_code=response.status_code, detail=f"Translation Error: {response.text}")
            
        result = response.json()
        # Assuming the API returns a list of translated texts under 'translations'
        translations = result.get("translations", [])
        if translations:
            return translations[0]
        return ""

async def text_to_speech(text: str, target_lang: str) -> bytes:
    """
    Converts translated text back to speech using Sarvam's Bulbul v3 model.
    """
    url = f"{BASE_URL}/text-to-speech"
    
    payload = {
        "inputs": [text],
        "target_language_code": target_lang,
        "model": "bulbul:v3",
        "speaker": "shubh" # Conversational male voice
    }

    async with httpx.AsyncClient() as client:
        headers = {**HEADERS, "Content-Type": "application/json"}
        response = await client.post(url, headers=headers, json=payload, timeout=30.0)
        
        if response.status_code != 200:
            raise HTTPException(status_code=response.status_code, detail=f"TTS Error: {response.text}")
            
        result = response.json()
        
        # Sarvam's TTS returns a base64 encoded audio string
        audios = result.get("audios", [])
        if audios:
            # Decode the base64 string back into raw audio bytes
            audio_bytes = base64.b64decode(audios[0])
            return audio_bytes
        
        raise HTTPException(status_code=500, detail="No audio returned from TTS")