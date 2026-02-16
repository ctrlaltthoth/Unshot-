import Foundation
import Vision

public final class OCRPipeline {
    public init() {}

    public func recognizeText(cgImage: CGImage) async throws -> OCRDocument {
        let fast = try performRequest(cgImage: cgImage, level: .fast)
        if fast.fullText.count > 60 {
            return fast
        }
        return try performRequest(cgImage: cgImage, level: .accurate)
    }

    private func performRequest(cgImage: CGImage, level: VNRequestTextRecognitionLevel) throws -> OCRDocument {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = level
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([request])
        let observations = (request.results ?? []).compactMap { $0.topCandidates(1).first?.string }
        let text = observations.joined(separator: "\n")

        return OCRDocument(
            id: UUID().uuidString,
            assetId: UUID().uuidString,
            fullText: text,
            blocks: observations,
            languageHints: [],
            createdAt: Date(),
            ocrVersion: "vision-v1",
            quality: level == .fast ? .fast : .accurate
        )
    }
}
