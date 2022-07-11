"""
This Module has the definition for the Hello App

It consist on a AWS Lambda Handler that will return a Hello Message
based on API Parameter invocation.
"""
import logging
import json
from aws_lambda_powertools.utilities.typing import LambdaContext


log = logging.getLogger()
log.setLevel(logging.INFO)


def lambda_handler(event: dict, context: LambdaContext) -> dict:
    """
    Lambda Handler definition that returns Hello Message

    params:
        event: Lambda Event
        context: Lambda Context
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
