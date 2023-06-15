import json

def success_response(status_code, response_body):
    response = {
        'statusCode': status_code,
        'body': json.dumps(response_body)
    }
    return response
