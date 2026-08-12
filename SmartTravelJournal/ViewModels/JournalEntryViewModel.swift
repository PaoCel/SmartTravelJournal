import Foundation
import SwiftData

@Observable
final class JournalEntryViewModel {
    var title: String = ""
    var body: String = ""
    var mood: Mood = .calm
    var imageName: String = "trip_beach"
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var timestamp: Date = .now

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
        resetForm()
    }

    func deleteEntry(_ entry: JournalEntry, context: ModelContext) {
        context.delete(entry)
    }

    // Helpers

    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func resetForm() {
        title = ""
        body = ""
        mood = .calm
        imageName = "trip_beach"
        latitude = 0.0
        longitude = 0.0
        timestamp = .now
    }
}
