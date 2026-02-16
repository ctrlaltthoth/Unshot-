from unshot_core import parse_currency_totals, parse_ingredients


def test_receipt_total_parser():
    totals = parse_currency_totals("Subtotal 12.00\nTax 1.20\nTotal: 13.20")
    assert totals[-1] == 13.20


def test_ingredient_parser():
    items = parse_ingredients("Ingredients\n- 2 eggs\n- 1 cup milk\nMix")
    assert "2 eggs" in items
    assert "1 cup milk" in items
