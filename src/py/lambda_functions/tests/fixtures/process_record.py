from typing import Dict, Tuple

from pytest import fixture


@fixture
def process_record_input1() -> Dict:
    return {
        "data": "eyJldmVudF91dWlkIjogInRlc3RfdXVpZCIsICJldmVudF9uYW1lIjogInR5cGU6c3VidHlwZTpzdGF0dXMiLCAiY3JlYXRlZF9hdCI6IDE3MTc5NDc3ODd9"
    }


@fixture
def process_record_input2() -> Dict:
    return {
        "data": "eyJldmVudF91dWlkIjogInRlc3RfdXVpZCIsICJldmVudF9uYW1lIjogInR5cGUiLCAiY3JlYXRlZF9hdCI6IDE3MTc5NDc3ODd9"
    }


@fixture
def process_record_input3() -> Dict:
    return {
        "data": "eyJldmVudF91dWlkIjogInRlc3RfdXVpZCIsICJldmVudF9uYW1lIjogInR5cGU6c3VidHlwZTpzdGF0dXMifQ=="
    }


@fixture
def expected_output1() -> Tuple:
    return (
        {
            "created_at": 1717947787,
            "created_datetime": "2024-06-09T17:43:07",
            "event_name": "type:subtype:status",
            "event_subtype": "subtype",
            "event_type": "type",
            "event_uuid": "test_uuid",
        },
        "Ok",
    )


@fixture
def expected_output_for_invalid_input() -> Tuple:
    return {}, "Failed"
