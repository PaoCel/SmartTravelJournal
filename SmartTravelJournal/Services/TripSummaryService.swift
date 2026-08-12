import Foundation
import FoundationModels

/// Il servizio riceve testo già estratto dal modello, non l'oggetto `Trip`:
/// i tipi `@Model` non sono `Sendable` e non possono attraversare il confine
/// di concorrenza di `withTimeout`.
final class TripSummaryService: Sendable {
    func generateSummary(tripTitle: String, entriesText: String) async throws -> TripSummary {
        switch SystemLanguageModel.default.availability {
        case .available:
            break
        default:
            throw AIError.unavailable("AI features require Apple Intelligence.")
        }

        let prompt = "Summarize this travel journal for a trip called '\(tripTitle)':\n\(entriesText)"

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
