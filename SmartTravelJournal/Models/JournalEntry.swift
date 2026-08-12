import Foundation
import SwiftData

@Model
final class JournalEntry {
    @Attribute(.unique) var id: UUID
    var title: String
    var body: String
    var moodRawValue: String
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var imageName: String
    var smartTagsCSV: String?

    var trip: Trip?

    init(
        id: UUID = UUID(),
        title: String,
        body: String,
        mood: Mood,
        latitude: Double,
        longitude: Double,
        timestamp: Date = .now,
        imageName: String = "trip_beach",
        smartTagsCSV: String? = nil
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.moodRawValue = mood.rawValue
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.imageName = imageName
        self.smartTagsCSV = smartTagsCSV
    }

    var mood: Mood {
        get { Mood(rawValue: moodRawValue) ?? .calm }
        set { moodRawValue = newValue.rawValue }
    }
}
