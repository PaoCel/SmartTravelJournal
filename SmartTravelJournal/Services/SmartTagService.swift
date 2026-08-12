import Foundation
import FoundationModels

/// Come `TripSummaryService`: riceve i campi della entry, non il `@Model`,
/// che non è `Sendable`.
final class SmartTagService: Sendable {
    func generateTags(entryTitle: String, entryBody: String) async throws -> SmartTags {
        switch SystemLanguageModel.default.availability {
        case .available:
            break
        default:
            throw AIError.unavailable("AI features require Apple Intelligence.")
        }

        let prompt = "Generate content tags for this journal entry titled '\(entryTitle)': \(entryBody)"

        let session = LanguageModelSession(
            instructions: "You are a travel journal assistant. Generate short, relevant content tags for journal entries."
        )

        let response = try await session.respond(
            to: prompt,
            generating: SmartTags.self
        )

        return response.content
    }
}
