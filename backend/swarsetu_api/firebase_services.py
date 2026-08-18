import os
import uuid
import firebase_admin
from firebase_admin import credentials, firestore, storage
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# 1. Initialize Firebase Admin
# This requires a service account JSON file from your Firebase console.
# IMPORTANT: Never commit this JSON file to GitHub!
try:
    cred = credentials.Certificate("serviceAccountKey.json")
    bucket_name = os.getenv("FIREBASE_STORAGE_BUCKET")
    
    firebase_admin.initialize_app(cred, {
        'storageBucket': bucket_name
    })
    
    db = firestore.client()
    bucket = storage.bucket()
except Exception as e:
    print(f"Warning: Firebase initialization failed. Check your serviceAccountKey.json. Error: {e}")


async def upload_audio_to_storage(audio_bytes: bytes, filename: str) -> str:
    """
    Uploads raw audio bytes to Firebase Cloud Storage and returns a public URL.
    """
    # Create a unique filename to prevent overwriting previous translations
    unique_filename = f"{uuid.uuid4()}_{filename}"
    blob = bucket.blob(f"audio_files/{unique_filename}")
    
    # Upload the file buffer
    blob.upload_from_string(audio_bytes, content_type="audio/wav")
    
    # Make it publicly readable so the Flutter frontend can play the URL
    blob.make_public()
    
    return blob.public_url


async def save_translation_to_firestore(
    user_id: str,
    source_url: str,
    source_text: str,
    target_text: str,
    target_audio_url: str,
    source_lang: str,
    target_lang: str
):
    """
    Saves the translation metadata to the Firestore NoSQL database.
    """
    doc_ref = db.collection('translations').document()
    
    doc_data = {
        'translation_id': doc_ref.id,
        'user_id': user_id,
        'source_audio_url': source_url,
        'source_text': source_text,
        'target_text': target_text,
        'target_audio_url': target_audio_url,
        'source_lang': source_lang,
        'target_lang': target_lang,
        'timestamp': firestore.SERVER_TIMESTAMP
    }
    
    doc_ref.set(doc_data)
    return doc_ref.id