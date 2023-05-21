import re
import sqlalchemy
from sqlalchemy import text
from sqlalchemy.ext.asyncio import create_async_engine
from fastapi import APIRouter
from app.db_connection_url import get_db_connection_url

router = APIRouter()

@router.get("/{table_name}/row-count")
async def root(table_name):
    if not table_name:
        raise ValueError("Bad call to API endpoint. A valid table name was not specified.")
    table_name = f'{table_name}'
    if not re.match(r"[A-Za-z0-9]", table_name):
        raise ValueError("Bad call to API endpoint. A valid table name was not specified.")
    table_name = table_name.strip()
    if re.match(r"[^A-Za-z0-9_-]", table_name):
        raise ValueError("Bad call to API end point. Table name parameter contains one or more invalid characters.")
    if len(table_name) > 32:
        raise ValueError("Bad call to API end point. A valid table name cannot exceed 32 characters.")
    row_count = 0
    db_url = get_db_connection_url()
    engine = create_async_engine(db_url)
    connection = await engine.connect()
    query_result = await connection.execute(text('select count(*) from {table_name}'))
    for row in query_result:
        print(f'type(row): {type(row)}')
        for value in row:
            row_count = value

    
    return {"message": row_count}