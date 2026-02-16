import Foundation

public struct Classifier {
    public init() {}

    public func classify(text: String) -> (Category, Double) {
        let lower = text.lowercased()
        let rules: [(Category, [String])] = [
            (.receipt, ["subtotal", "tax", "receipt", "total"]),
            (.recipe, ["ingredients", "instructions", "preheat", "serves"]),
            (.ticket, ["gate", "seat", "boarding", "ticket"]),
            (.confirmation, ["confirmation", "order", "booking", "reference"]),
            (.shoppingList, ["shopping list", "buy", "groceries"])
        ]

        let scored = rules.map { category, keywords in
            let count = keywords.filter { lower.contains($0) }.count
            return (category, min(1.0, Double(count) / Double(keywords.count)))
        }

        return scored.max(by: { $0.1 < $1.1 }) ?? (.misc, 0.0)
    }
}
