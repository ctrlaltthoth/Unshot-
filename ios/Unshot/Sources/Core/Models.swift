import Foundation

public enum ImportSource: String, Codable {
    case picker
    case photokit
}

public enum OCRQuality: String, Codable {
    case fast
    case accurate
}

public enum AssetMediaType: String, Codable {
    case image
    case livePhoto
    case unknown
}

public struct AssetRef: Codable, Identifiable, Hashable {
    public let id: String
    public let createdAt: Date
    public let pixelWidth: Int
    public let pixelHeight: Int
    public let fileSize: Int64
    public let mediaType: AssetMediaType
    public let importSource: ImportSource
}

public struct OCRDocument: Codable, Identifiable {
    public let id: String
    public let assetId: String
    public let fullText: String
    public let blocks: [String]
    public let languageHints: [String]
    public let createdAt: Date
    public let ocrVersion: String
    public let quality: OCRQuality
}

public struct ExtractedEntity: Codable {
    public let assetId: String
    public let urls: [String]
    public let phones: [String]
    public let emails: [String]
    public let detectedDates: [DetectedDate]
    public let currencyTotals: [DetectedCurrencyTotal]
}

public struct DetectedDate: Codable {
    public let value: Date
    public let confidence: Double
}

public struct DetectedCurrencyTotal: Codable {
    public let value: Double
    public let currency: String
    public let confidence: Double
}

public enum Category: String, Codable, CaseIterable {
    case receipt = "Receipt"
    case recipe = "Recipe"
    case ticket = "Ticket"
    case confirmation = "Confirmation"
    case shoppingList = "ShoppingList"
    case misc = "Misc"
}

public struct Classification: Codable {
    public let assetId: String
    public let category: Category
    public let confidence: Double
    public let userOverrideCategory: Category?
}

public enum ArtifactType: String, Codable {
    case expenseRow = "ExpenseRow"
    case shoppingList = "ShoppingList"
    case eventCard = "EventCard"
    case packSummary = "PackSummary"
    case snippet = "Snippet"
}

public struct Artifact: Codable, Identifiable {
    public let id: String
    public let assetId: String
    public let type: ArtifactType
    public let payload: [String: String]
}

public struct Pack: Codable, Identifiable {
    public let id: String
    public let title: String
    public let type: String
    public let createdAt: Date
    public let assetIds: [String]
    public let artifacts: [Artifact]
    public let exports: [PackExport]
}

public struct PackExport: Codable {
    public let path: String
    public let contentType: String
    public let createdAt: Date
}
