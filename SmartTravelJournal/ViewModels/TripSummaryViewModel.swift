import Foundation
import FoundationModels
import SwiftData

@Observable
final class TripSummaryViewModel {
    var summary: TripSummary? = nil
    var isGenerating: Bool = false
    var errorMessage: String? = nil
    var wasGeneratedByAI: Bool = false

    private let service = TripSummaryService()

    func generate(for trip: Trip, context: ModelContext) async {
        // Cache: se il riassunto è già stato generato non si rigenera.
        if let cached = trip.aiSummary {
            let highlights = trip.aiHighlightsCSV?
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty } ?? []
            summary = TripSummary(summary: cached, highlights: highlights)
            wasGeneratedByAI = true
            return
        }

        if case .unavailable = SystemLanguageModel.default.availability {
            summary = TripSummary(
                summary: "AI features require Apple Intelligence.",
                highlights: []
            )
            return
        }

        if trip.entries.isEmpty {
            summary = TripSummary(
                summary: "Add journal entries to generate an AI trip summary.",
                highlights: []
            )
            return
        }

        isGenerating = true
        errorMessage = nil

        do {
            let generated = try await withTimeout(seconds: 20) { [service] in
                try await service.generateSummary(for: trip)
            }
            summary = generated
            wasGeneratedByAI = true
            trip.aiSummary = generated.summary
            trip.aiHighlightsCSV = generated.highlights.joined(separator: ", ")
            try? context.save()
        } catch {
            errorMessage = "Unable to generate summary. Please try again."
        }

        isGenerating = false
    }

    func retry(for trip: Trip, context: ModelContext) async {
        summary = nil
        wasGeneratedByAI = false
        trip.aiSummary = nil
        trip.aiHighlightsCSV = nil
        await generate(for: trip, context: context)
    }
}
