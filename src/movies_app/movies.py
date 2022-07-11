"""
This Module has the definition for the Movies App

It consists on a AWS Lambda Handler that will load
movie titles into a Dynamo DB Table based on API Parameter invocation.
"""
import os
import json
import logging
from boto3 import client
from aws_lambda_powertools.utilities.typing import LambdaContext


log = logging.getLogger()
log.setLevel(logging.INFO)
dynamodb_client = client('dynamodb')


def lambda_handler(event: dict, context: LambdaContext):
    """
    Lambda Handler definition that loads movies into DDB

    Environmental Variables
        DDB_TABLE: The Dynamo DB Table Name

    Params:
        event: Lambda Event
        context: Lambda Context
    """
    log.info('## Context function_name: %s',
             context.function_name if context else 'no-context')

    log.info('## Event: %s', event)
    table = os.environ.get('DDB_TABLE')
    log.info("## Loaded table name from environemt: %s", table)

    if event["body"]:
        item = json.loads(event["body"])
        log.info("## Received payload: %s", item)
        year = str(item["year"])
        title = str(item["title"])
        ddb_item = {"year": {'N':year}, "title": {'S':title}}
        dynamodb_client.put_item(
            TableName=table,
            Item=ddb_item)

    else:
        logging.info("## Received request without a payload")
        ddb_default_item = {"year": {'N':'2012'}, "title": {'S':'The Amazing Spider-Man 2'}}
        dynamodb_client.put_item(TableName=table,Item=ddb_default_item)

    msg = "Successfully inserted data!"
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({"message": msg})
    }
