"""
WIP
"""
import logging
import json


log = logging.getLogger()
log.setLevel(logging.INFO)


def lambda_handler(event: dict, context: object) -> dict:
    """
    WIP
    """
    log.info('## Context function_name: %s',
             context.function_name if context else 'no-context')

    log.info('## Event: %s', event)

    query_string_params = event.get('queryStringParameters')
    name = query_string_params.get('Name') if query_string_params else 'Lambda'
    msg = {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
        },
        'body': json.dumps(f'Hello {name}!')
    }

    return msg


if __name__ == '__main__':
    response = lambda_handler(event={'event': 'test'}, context=None)

    print(response)
