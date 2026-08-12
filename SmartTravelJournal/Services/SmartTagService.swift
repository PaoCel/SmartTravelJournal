import Foundation
import FoundationModels
import SwiftData

final class SmartTagService {
    func generateTags(for entry: JournalEntry) async throws -> SmartTags {
        switch SystemLanguageModel.default.availability {
        case .available:
            break
        default:
            throw AIError.unavailable("AI features require Apple Intelligence.")
        }

        let prompt = "Generate content tags for this journal entry titled '\(entry.title)': \(entry.body)"

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
