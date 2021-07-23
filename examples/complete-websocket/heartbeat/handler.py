import logging
from datetime import datetime, timezone
from pathlib import Path

import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)


API_URL = Path("./api_url").read_text()


def lambda_handler(event, _):
    table_name = "aws-ws-connections"

    connection_id = event.get("requestContext", {}).get("connectionId")

    table = boto3.resource("dynamodb").Table(table_name)

    connection_ids = []

    try:
        scan_response = table.scan(ProjectionExpression="connection_id")
        connection_ids = [item["connection_id"] for item in scan_response["Items"]]
        logger.info("Found %s active connections.", len(connection_ids))
    except ClientError:
        logger.exception("Couldn't get connections.")

    message = f"PING? {datetime.now(tz=timezone.utc)}"
    logger.info("Message: %s", message)

    apig_management_client = boto3.client(
        "apigatewaymanagementapi", endpoint_url=API_URL
    )

    for other_conn_id in connection_ids:
        try:
            if other_conn_id != connection_id:
                send_response = apig_management_client.post_to_connection(
                    Data=message, ConnectionId=other_conn_id
                )
                logger.info(
                    "Posted message to connection %s, got response %s.",
                    other_conn_id,
                    send_response,
                )
        except ClientError:
            logger.exception("Couldn't post to connection %s.", other_conn_id)
        except apig_management_client.exceptions.GoneException:
            logger.info("Connection %s is gone, removing.", other_conn_id)
            try:
                table.delete_item(Key={"connection_id": other_conn_id})
            except ClientError:
                logger.exception("Couldn't remove connection %s.", other_conn_id)
