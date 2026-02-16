import re
from dataclasses import dataclass


CATEGORIES = {
    "Receipt": ["subtotal", "tax", "receipt", "total"],
    "Recipe": ["ingredients", "instructions", "preheat", "serves"],
    "Ticket": ["gate", "seat", "boarding", "ticket"],
    "Confirmation": ["confirmation", "order", "booking", "reference"],
    "ShoppingList": ["shopping list", "buy", "groceries"],
}


def classify(text: str):
    lower = text.lower()
    best = ("Misc", 0.0)
    for cat, keys in CATEGORIES.items():
        score = sum(k in lower for k in keys) / len(keys)
        if score > best[1]:
            best = (cat, score)
    return best


def parse_currency_totals(text: str):
    matches = re.findall(r"(?:total|amount)\s*[:$]?\s*([0-9]+(?:\.[0-9]{2})?)", text.lower())
    return [float(m) for m in matches]


def parse_ingredients(text: str):
    lines = [l.strip(" -") for l in text.splitlines() if l.strip()]
    return [l for l in lines if re.search(r"\d", l) or l.startswith("-")]


@dataclass
class Asset:
    id: str
    pixel_size: tuple[int, int]
    file_size: int
    created_at: int


def exact_dupe_groups(assets: list[Asset]):
    groups = {}
    for a in assets:
        k = (a.id, a.pixel_size, a.file_size, a.created_at)
        groups.setdefault(k, []).append(a.id)
    return [v for v in groups.values() if len(v) > 1]


def near_dupe_score(distance: float):
    return max(0.0, 1 - min(1.0, distance / 20))
