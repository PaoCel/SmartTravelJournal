import Foundation
import FoundationModels
import SwiftData

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

        do {
            let generated = try await withTimeout(seconds: 20) { [service] in
                try await service.generateTags(for: entry)
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
