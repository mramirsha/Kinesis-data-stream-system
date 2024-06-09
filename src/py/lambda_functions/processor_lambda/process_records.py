import base64
import json
import logging
from datetime import datetime
from typing import Dict, Tuple

logger = logging.getLogger(__name__)


def process_record(record) -> Tuple[Dict, str]:
    """
    Adding three more field to this record and return it

    Args:
        record:

    Returns:
        Processed record:
        Result of processing: ["Ok"|"Failed"]

    Raises:
        IndexError: Catching this error if the event_name field is missing or is empty
    """
    try:
        logger.info(f"Processing record: {record.get('recordId')}")
        payload = base64.b64decode(record["data"]).decode("utf-8")
        parsed_payload: Dict = json.loads(payload)
        event_name: str = parsed_payload.get("event_name")
        created_at = parsed_payload.get("created_at")
        parsed_payload["event_type"] = event_name.split(":")[0]
        parsed_payload["event_subtype"] = event_name.split(":")[1]
        parsed_payload["created_datetime"] = datetime.fromtimestamp(
            int(created_at)
        ).isoformat()  # I assumed that created_at is unix timestamp in second and not millisecond
        return parsed_payload, "Ok"
    except IndexError as ie:
        logger.error(
            f"The event_name field in the following record is null: \n{parsed_payload}"
        )
        return {}, "Failed"
    except Exception as error:
        logger.error(error)
        return {}, "Failed"


def lambda_handler(event, context):
    output_records = []
    logger.info(f"----- Started processing records -----")
    for record in event["Records"]:
        processed_record, result = process_record(record)
        output_record = {
            "recordId": record["recordId"],
            "result": result,
            "data": base64.b64encode(
                json.dumps(processed_record).encode("utf-8")
            ).decode("utf-8"),
        }
        output_records.append(output_record)
    logger.info(f"----- Finished processing records -----")
    return output_records
