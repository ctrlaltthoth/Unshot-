import Foundation
import Vision

public struct DuplicateGroup: Identifiable {
    public let id: String
    public let assetIds: [String]
    public let reason: String
}

public final class DedupeService {
    public init() {}

    public func exactDuplicateGroups(assets: [AssetRef]) -> [DuplicateGroup] {
        let grouped = Dictionary(grouping: assets) { "\($0.id)|\($0.pixelWidth)x\($0.pixelHeight)|\($0.fileSize)|\($0.createdAt.timeIntervalSince1970)" }
        return grouped.values.filter { $0.count > 1 }.map {
            DuplicateGroup(id: UUID().uuidString, assetIds: $0.map(\.id), reason: "exact-metadata")
        }
    }

    public func nearDuplicateScore(_ lhs: VNFeaturePrintObservation, _ rhs: VNFeaturePrintObservation) -> Float {
        var distance: Float = 100
        try? lhs.computeDistance(&distance, to: rhs)
        return max(0, 1 - min(1, distance / 20))
    }
}
