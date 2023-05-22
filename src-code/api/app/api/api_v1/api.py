from fastapi import APIRouter

from .endpoints import users, current_utc_datetime, show_tables, hello, hello_world, query

router = APIRouter()
router.include_router(users.router, prefix='/users', tags=['Users'])
router.include_router(current_utc_datetime.router, prefix='/current-utc-datetime', tags=['CurrentUtcDatetime'])
router.include_router(show_tables.router, prefix='/show-tables', tags=['ShowTables'])
router.include_router(hello.router, prefix='/hello', tags=['Hello'])
router.include_router(hello_world.router, prefix='/hello-world', tags=['HelloWorld'])
router.include_router(query.router, prefix='/query', tags=['Query'])
