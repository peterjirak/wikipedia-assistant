from fastapi import APIRouter

from .endpoints import users, current_utc_datetime, show_tables

router = APIRouter()
router.include_router(users.router, prefix='/users', tags=['Users'])
router.include_router(current_utc_datetime.router, prefix='/current-utc-datetime', tags=['CurrentUtcDatetime'])
router.include_router(show_tables.router, prefix='/show-tables', tags=['ShowTables'])