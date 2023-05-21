from datetime import datetime, timezone
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def root():
    now_obj = datetime.now(timezone.utc)
    now_str = f'{now_obj}'
    return {"message": now_str}
