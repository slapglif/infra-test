import json

def success(body):
    response = {
        "statusCode": 200,
        "body": json.dumps(body)
    }

    return response