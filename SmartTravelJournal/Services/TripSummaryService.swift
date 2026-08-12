import Foundation
import FoundationModels
import SwiftData

final class TripSummaryService {
    func generateSummary(for trip: Trip) async throws -> TripSummary {
        switch SystemLanguageModel.default.availability {
        case .available:
            break
        default:
            throw AIError.unavailable("AI features require Apple Intelligence.")
        }

        let entriesText = trip.entries
            .sorted { $0.timestamp < $1.timestamp }
            .map { "\($0.title): \($0.body)" }
            .joined(separator: "\n")

        let prompt = "Summarize this travel journal for a trip called '\(trip.title)':\n\(entriesText)"

        let session = LanguageModelSession(
            instructions: "You are a travel journal assistant. Generate concise, enthusiastic summaries of travel experiences."
        )

        let response = try await session.respond(
            to: prompt,
            generating: TripSummary.self
        )

        return response.content
    }
}
