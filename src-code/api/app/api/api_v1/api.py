from fastapi import APIRouter

from .endpoints import current_utc_datetime, show_tables, hello, hello_world, query, table_row_count, most_out_of_date_page_for_category

router = APIRouter()
router.include_router(current_utc_datetime.router, prefix='/current-utc-datetime', tags=['CurrentUtcDatetime'])
router.include_router(show_tables.router, prefix='/show-tables', tags=['ShowTables'])
router.include_router(hello.router, prefix='/hello', tags=['Hello'])
router.include_router(hello_world.router, prefix='/hello-world', tags=['HelloWorld'])
router.include_router(query.router, prefix='/query', tags=['Query'])
router.include_router(table_row_count.router, prefix='/table-row-count', tags=['TableRowCount'])
router.include_router(most_out_of_date_page_for_category.router, prefix='/most-out-of-date-page-for-category', tags=['MostOutOfDatePageForCategory'])
