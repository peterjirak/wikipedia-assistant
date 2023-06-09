import sqlalchemy
from sqlalchemy import text
from sqlalchemy.ext.asyncio import create_async_engine
from fastapi import APIRouter
from app.db_connection_url import get_db_connection_url

router = APIRouter()

@router.get("/")
async def root():
    tables = []
    db_url = get_db_connection_url()
    engine = create_async_engine(db_url)
    connection = await engine.connect()
    query_result = await connection.execute(text('show tables'))
    for row in query_result:
        for value in row:
            tables.append(value)
    
    return {"message": tables}
