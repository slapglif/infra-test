import json
from ..utils.response.errors import error_response

def error_handler(e):
    error_message = str(e)
    print(f'Error: {error_message}')
    return error_response(500, 'Internal Server Error')
