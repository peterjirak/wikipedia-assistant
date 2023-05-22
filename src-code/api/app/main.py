import re

import sqlalchemy
from sqlalchemy import text
from sqlalchemy.ext.asyncio import create_async_engine
from fastapi import FastAPI
from app.db_connection_url import get_db_connection_url
from app.api.api_v1.api import router as api_router

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/api/v1/table/{table_name}/row_count")
async def get_row_count_for_table(table_name):
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
    query_result = await connection.execute(text(f'select count(*) from {table_name}'))
    for row in query_result:
        print(f'type(row): {type(row)}')
        for value in row:
            row_count = value

    
    return {"message": row_count}

app.include_router(api_router, prefix="/api/v1")
