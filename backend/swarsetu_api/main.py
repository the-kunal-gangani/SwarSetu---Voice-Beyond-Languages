from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import os
import uuid

# Import your custom service wrappers
from sarvam_services import speech_to_text, translate_text, text_to_speech
from firebase_services import upload_audio_to_storage, save_translation_to_firestore

app = FastAPI(title="SwarSetu API", version="1.0.0")

# Allow CORS for Flutter client testing (Web & Mobile)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Create a local directory for audio files if Firebase isn't ready
os.makedirs("local_audio", exist_ok=True)
# Mount the directory so files can be accessed via URL
app.mount("/static", StaticFiles(directory="local_audio"), name="static")

@app.get("/")
async def root():
    return {"message": "Welcome to the SwarSetu API!"}

@app.post("/api/v1/translate")
async def process_translation(
    user_id: str = Form("test_user_01"),
    source_lang: str = Form(...),
    target_lang: str = Form(...),
    audio: UploadFile = File(...)
):
    try:
        # 1. Read incoming audio buffer
        audio_bytes = await audio.read()
        
        # 2. Extract text from speech using Sarvam Saaras
        source_text = await speech_to_text(audio_bytes, audio.filename)
        if not source_text:
            raise HTTPException(status_code=400, detail="Could not transcribe audio. Please try again.")
            
        # 3. Translate the text using Sarvam Mayura
        target_text = await translate_text(source_text, source_lang, target_lang)
        
        # 4. Generate spoken audio of the translation using Sarvam Bulbul
        target_audio_bytes = await text_to_speech(target_text, target_lang)
        
        # 5. Storage Handling (Firebase with a Local Fallback)
        try:
            # Attempt to use Firebase
            target_audio_url = await upload_audio_to_storage(target_audio_bytes, f"out_{user_id}.wav")
            await save_translation_to_firestore(
                user_id, "", source_text, target_text, target_audio_url, source_lang, target_lang
            )
            storage_method = "firebase"
            
        except Exception as e:
            # Fallback: Save locally if Firebase throws an error (e.g., missing credentials)
            print(f"Firebase bypassed. Saving locally. Reason: {e}")
            local_filename = f"{uuid.uuid4()}.wav"
            local_filepath = os.path.join("local_audio", local_filename)
            
            with open(local_filepath, "wb") as f:
                f.write(target_audio_bytes)
                
            # Generate a localhost URL for immediate playback
            target_audio_url = f"http://localhost:8000/static/{local_filename}"
            storage_method = "local_storage"

        # 6. Return the JSON payload to the client
        return {
            "source_text": source_text,
            "target_text": target_text,
            "audio_url": target_audio_url,
            "storage_method": storage_method
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))