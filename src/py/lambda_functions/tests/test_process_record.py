from processor_lambda.process_records import process_record


def test_process_record(process_record_input1, expected_output1):
    assert process_record(process_record_input1) == expected_output1


def test_process_record_with_invalid_event_name(
    process_record_input2, expected_output_for_invalid_input
):
    assert process_record(process_record_input2) == expected_output_for_invalid_input


def test_process_record_without_created_at(
    process_record_input3, expected_output_for_invalid_input
):
    assert process_record(process_record_input3) == expected_output_for_invalid_input
