import Foundation
import SwiftData

@Model
final class Trip {
    @Attribute(.unique) var id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var coverImageName: String
    var aiSummary: String?

    @Relationship(deleteRule: .cascade, inverse: \JournalEntry.trip)
    var entries: [JournalEntry] = []

    init(
        id: UUID = UUID(),
        title: String,
        startDate: Date,
        endDate: Date,
        coverImageName: String = "trip_beach",
        aiSummary: String? = nil
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.coverImageName = coverImageName
        self.aiSummary = aiSummary
    }
}
