import Foundation

public actor IndexingJobQueue {
    public enum JobState: String {
        case queued
        case running
        case cancelled
        case failed
        case complete
    }

    public struct Job: Identifiable {
        public let id: String
        public let assetId: String
        public var attempts: Int
        public var state: JobState

        public init(assetId: String) {
            self.id = UUID().uuidString
            self.assetId = assetId
            self.attempts = 0
            self.state = .queued
        }
    }

    private var queue: [Job] = []
    private var cancelled: Set<String> = []
    private let maxAttempts = 3

    public func enqueue(assetIds: [String]) {
        queue.append(contentsOf: assetIds.map(Job.init))
    }

    public func cancel(assetId: String) {
        cancelled.insert(assetId)
    }

    public func next() async -> Job? {
        guard !queue.isEmpty else { return nil }
        var job = queue.removeFirst()
        if cancelled.contains(job.assetId) {
            job.state = .cancelled
            return job
        }
        job.state = .running
        return job
    }

    public func complete(job: Job) {
        // persistence hook for SQLite/GRDB in production
        _ = job
    }

    public func fail(job: Job) {
        var failedJob = job
        failedJob.attempts += 1
        if failedJob.attempts < maxAttempts {
            let delay = UInt64(pow(2.0, Double(failedJob.attempts)) * 250_000_000)
            Task {
                try? await Task.sleep(nanoseconds: delay)
                await self.requeue(job: failedJob)
            }
        }
    }

    private func requeue(job: Job) {
        queue.append(job)
    }
}
