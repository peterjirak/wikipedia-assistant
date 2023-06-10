
# f"mysql+pymysql://{connection_info['user']}:{connection_info['password']}@{connection_info['host']}:{connection_info['port']}/{connection_info['database']}?charset=utf8mb4"

def get_db_config():
    return {
        'host': 'HOST',
        'user': 'USER',
        'password': 'PASSWORD',
        'port': 9999,
        'database': 'wikipedia_assistant'
    }

def get_db_connection_url():
    db_config = get_db_config()
    db_url = f"mysql+asyncmy://{db_config['user']}:{db_config['password']}@{db_config['host']}:{db_config['port']}/{db_config['database']}?charset=utf8mb4"
    return db_url
