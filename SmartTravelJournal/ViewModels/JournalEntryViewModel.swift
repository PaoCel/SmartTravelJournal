import Foundation
import SwiftData

@MainActor
@Observable
final class JournalEntryViewModel {
    var title: String = ""
    var body: String = ""
    var mood: Mood = .calm
    var imageName: String = "trip_beach"
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var timestamp: Date = .now

    /// Ricerca nelle entry di un viaggio, come `TripsViewModel.searchText` per i viaggi.
    var searchText: String = ""

    // Search

    func filteredEntries(_ entries: [JournalEntry]) -> [JournalEntry] {
        if searchText.isEmpty { return entries }
        return entries.filter {
            $0.title.localizedStandardContains(searchText)
                || $0.body.localizedStandardContains(searchText)
        }
    }

    // Load / Update

    func load(from entry: JournalEntry) {
        title = entry.title
        body = entry.body
        mood = entry.mood
        imageName = entry.imageName
        latitude = entry.latitude
        longitude = entry.longitude
        timestamp = entry.timestamp
    }

    func updateEntry(_ entry: JournalEntry, context: ModelContext) {
        entry.title = title
        entry.body = body
        entry.mood = mood
        entry.imageName = imageName
        entry.latitude = latitude
        entry.longitude = longitude
        entry.timestamp = timestamp
        // I tag erano stati generati sul testo precedente: si invalidano.
        entry.smartTagsCSV = nil
        // Anche il riassunto del viaggio parlava del contenuto vecchio.
        entry.trip?.aiSummary = nil
        entry.trip?.aiHighlightsCSV = nil
        resetForm()
    }

    // Save

    func saveEntry(to trip: Trip, context: ModelContext) {
        let entry = JournalEntry(
            title: title,
            body: body,
            mood: mood,
            latitude: latitude,
            longitude: longitude,
            timestamp: timestamp,
            imageName: imageName
        )
        trip.entries.append(entry)
        context.insert(entry)
        // Il riassunto in cache non conosce questa entry: si rigenera.
        trip.aiSummary = nil
        trip.aiHighlightsCSV = nil
        resetForm()
    }

    func deleteEntry(_ entry: JournalEntry, context: ModelContext) {
        entry.trip?.aiSummary = nil
        entry.trip?.aiHighlightsCSV = nil
        context.delete(entry)
    }

    // Helpers

    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func resetForm() {
        title = ""
        body = ""
        mood = .calm
        imageName = "trip_beach"
        latitude = 0.0
        longitude = 0.0
        timestamp = .now
    }
}
