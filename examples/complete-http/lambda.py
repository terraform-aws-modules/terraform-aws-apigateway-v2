import json

def handler(event, context):
    print(json.dumps(event))

    return event
