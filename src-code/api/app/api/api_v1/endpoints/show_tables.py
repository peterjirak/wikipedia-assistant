import sqlalchemy
from sqlalchemy import text
from fastapi import APIRouter
from app.db_config import get_db_config

router = APIRouter()

@router.get("/")
async def root():
    tables = []
    connection_info = get_db_config()
    engine = sqlalchemy.create_engine(f"mysql+pymysql://{connection_info['user']}:{connection_info['password']}@{connection_info['host']}:{connection_info['port']}/{connection_info['database']}?charset=utf8mb4")

    with engine.connect() as connection:
        query_result = connection.execute(text('show tables'));
    tables = query_result.all()

    return {"tables": tables}
