from unshot_core import classify


def test_receipt_classification():
    category, confidence = classify("Receipt\nSubtotal 8.00\nTax 1.00\nTotal 9.00")
    assert category == "Receipt"
    assert confidence >= 0.5


def test_ticket_classification():
    category, confidence = classify("Boarding pass\nGate A12\nSeat 14C")
    assert category == "Ticket"
    assert confidence >= 0.5
