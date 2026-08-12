import Foundation
import FoundationModels
import SwiftData

@MainActor
@Observable
final class SmartTagViewModel {
    var tags: [String] = []
    var isGenerating: Bool = false
    var errorMessage: String? = nil

    private let service = SmartTagService()

    func generate(for entry: JournalEntry, context: ModelContext) async {
        if let cached = entry.smartTagsCSV {
            tags = cached.components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            return
        }

        if case .unavailable = SystemLanguageModel.default.availability {
            tags = ["travel", "journal"]
            return
        }

        isGenerating = true
        errorMessage = nil

        // Come in `TripSummaryViewModel`: i campi si leggono prima, `JournalEntry`
        // è un `@Model` e non attraversa il confine di concorrenza.
        let entryTitle = entry.title
        let entryBody = entry.body

        do {
            let generated = try await withTimeout(seconds: 20) { [service] in
                try await service.generateTags(entryTitle: entryTitle, entryBody: entryBody)
            }
            tags = generated.tags
            entry.smartTagsCSV = generated.tags.joined(separator: ", ")
            try? context.save()
        } catch {
            tags = ["travel", "journal"]
        }

        isGenerating = false
    }
}
