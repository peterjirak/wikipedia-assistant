import re
from datetime import datetime, timezone
from fastapi import APIRouter

router = APIRouter()

@router.get("/{name}")
async def root(name):
    greeting = ''
    if not name or not re.match(r"\S", name):
        greeting = 'Hello, World!'
    else:
        name = name.strip()
        greeting = f"Hello, {name}"
    return {"message": greeting}
