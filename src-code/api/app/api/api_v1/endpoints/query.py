import re
import sqlalchemy
from sqlalchemy import text
from sqlalchemy.ext.asyncio import create_async_engine
from fastapi import APIRouter
from app.db_connection_url import get_db_connection_url

router = APIRouter()

@router.get("/{query}")
async def root(query):
    if (not query or
        not re.match(r"\S", query) or
        (not re.match(r"\bSELECT\b", query, flags=re.IGNORECASE) and not re.match(r"\bSHOW\b", query, re.IGNORECASE))):
        raise ValueError("Bad call to API endpoint. A valid query was not specified.")
    matches = []
    db_url = get_db_connection_url()
    engine = create_async_engine(db_url)
    connection = await engine.connect()
    query_result = await connection.execute(text(query))
    for row in query_result:
        matches.append(row._mapping)
    
    return {"message": matches}
