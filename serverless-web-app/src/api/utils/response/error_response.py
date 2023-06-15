import json

def error_response(status_code, message):
    response = {
        'statusCode': status_code,
        'body': json.dumps({'message': message})
    }
    return response
