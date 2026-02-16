from unshot_core import Asset, exact_dupe_groups, near_dupe_score


def test_exact_dupes_grouped():
    assets = [
        Asset("a", (100, 100), 2000, 10),
        Asset("a", (100, 100), 2000, 10),
        Asset("b", (120, 120), 2200, 11),
    ]
    groups = exact_dupe_groups(assets)
    assert len(groups) == 1
    assert groups[0] == ["a", "a"]


def test_near_dupe_score():
    assert near_dupe_score(0.5) > 0.9
    assert near_dupe_score(30) == 0.0
