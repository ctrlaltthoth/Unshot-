import Foundation

public struct ExtractionContext {
    public let text: String
    public let entities: ExtractedEntity
    public let metadata: AssetRef
}

public protocol Extractor {
    var name: String { get }
    func canHandle(context: ExtractionContext) -> Double
    func extract(context: ExtractionContext) -> [Artifact]
}

public struct ReceiptExtractor: Extractor {
    public let name = "ReceiptExtractor"

    public func canHandle(context: ExtractionContext) -> Double {
        let text = context.text.lowercased()
        let receiptSignals = ["subtotal", "tax", "total", "visa", "thank you"]
        return min(1, Double(receiptSignals.filter { text.contains($0) }.count) * 0.2)
    }

    public func extract(context: ExtractionContext) -> [Artifact] {
        guard let total = context.entities.currencyTotals.max(by: { $0.value < $1.value }) else { return [] }
        return [Artifact(id: UUID().uuidString, assetId: context.metadata.id, type: .expenseRow, payload: [
            "date": ISO8601DateFormatter().string(from: context.metadata.createdAt),
            "merchant": inferMerchant(from: context.text),
            "total": String(format: "%.2f", total.value),
            "currency": total.currency,
            "notes": "Auto-extracted on-device"
        ])]
    }

    private func inferMerchant(from text: String) -> String {
        text.split(separator: "\n").first.map(String.init) ?? "Unknown"
    }
}

public struct RecipeExtractor: Extractor {
    public let name = "RecipeExtractor"

    public func canHandle(context: ExtractionContext) -> Double {
        let t = context.text.lowercased()
        let recipeSignals = ["ingredients", "preheat", "serves", "teaspoon", "cup"]
        return min(1, Double(recipeSignals.filter { t.contains($0) }.count) * 0.25)
    }

    public func extract(context: ExtractionContext) -> [Artifact] {
        let items = context.text
            .split(separator: "\n")
            .filter { $0.contains("-") || $0.rangeOfCharacter(from: .decimalDigits) != nil }
            .prefix(20)
            .map { $0.replacingOccurrences(of: "-", with: "").trimmingCharacters(in: .whitespaces) }
            .joined(separator: " | ")
        return [Artifact(id: UUID().uuidString, assetId: context.metadata.id, type: .shoppingList, payload: [
            "items": items,
            "source": "recipe"
        ])]
    }
}

public struct TicketExtractor: Extractor {
    public let name = "TicketExtractor"

    public func canHandle(context: ExtractionContext) -> Double {
        let t = context.text.lowercased()
        let signals = ["gate", "seat", "boarding", "admit one", "section"]
        return min(1, Double(signals.filter { t.contains($0) }.count) * 0.25)
    }

    public func extract(context: ExtractionContext) -> [Artifact] {
        [Artifact(id: UUID().uuidString, assetId: context.metadata.id, type: .eventCard, payload: [
            "dateTime": ISO8601DateFormatter().string(from: context.metadata.createdAt),
            "venue": guessField(in: context.text, key: "venue"),
            "seatOrGate": guessSeatOrGate(in: context.text),
            "referenceCode": guessReference(in: context.text)
        ])]
    }

    private func guessField(in text: String, key: String) -> String {
        text.split(separator: "\n").first(where: { $0.lowercased().contains(key) }).map(String.init) ?? "Unknown"
    }

    private func guessSeatOrGate(in text: String) -> String {
        text.split(separator: "\n").first(where: { $0.lowercased().contains("seat") || $0.lowercased().contains("gate") }).map(String.init) ?? "Unknown"
    }

    private func guessReference(in text: String) -> String {
        text.split(separator: " ").first(where: { $0.count >= 6 && $0.rangeOfCharacter(from: .letters) != nil && $0.rangeOfCharacter(from: .decimalDigits) != nil }).map(String.init) ?? "N/A"
    }
}

public struct ConfirmationExtractor: Extractor {
    public let name = "ConfirmationExtractor"

    public func canHandle(context: ExtractionContext) -> Double {
        let t = context.text.lowercased()
        let signals = ["confirmation", "order #", "booking", "reference", "itinerary"]
        return min(1, Double(signals.filter { t.contains($0) }.count) * 0.2)
    }

    public func extract(context: ExtractionContext) -> [Artifact] {
        [Artifact(id: UUID().uuidString, assetId: context.metadata.id, type: .packSummary, payload: [
            "headline": context.text.split(separator: "\n").prefix(2).joined(separator: " "),
            "urls": context.entities.urls.joined(separator: ", "),
            "emails": context.entities.emails.joined(separator: ", ")
        ])]
    }
}

public struct GenericExtractor: Extractor {
    public let name = "GenericExtractor"

    public func canHandle(context: ExtractionContext) -> Double { 0.1 }

    public func extract(context: ExtractionContext) -> [Artifact] {
        [Artifact(id: UUID().uuidString, assetId: context.metadata.id, type: .snippet, payload: [
            "snippet": String(context.text.prefix(220)),
            "urls": context.entities.urls.joined(separator: ", ")
        ])]
    }
}
