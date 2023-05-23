import re
import sqlalchemy
from sqlalchemy import text
from sqlalchemy.ext.asyncio import create_async_engine
from fastapi import APIRouter
from app.db_connection_url import get_db_connection_url

router = APIRouter()

@router.get("/{category}")
async def root(category):
    if not category or not re.match(r"\S", category):
        raise ValueError("Bad call to API endpoint. A valid category was not specified.")
    query = text(f"SELECT * FROM most_outdated_page_for_ten_categories_with_most_pages WHERE cat_title = '{category}'")
    category = category.split()
    matches = []
    db_url = get_db_connection_url()
    engine = create_async_engine(db_url)
    connection = await engine.connect()
    query_result = await connection.execute(query)
    for row in query_result:
        matches.append(row._mapping)
    
    return {"message": matches}
