import Foundation
import SwiftData
@testable import SmartTravelJournal

/// Container SwiftData solo in memoria: ogni test parte da zero e non tocca
/// lo store dell'app.
@MainActor
enum TestSupport {
    static func makeContainer() throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: Trip.self, JournalEntry.self,
            configurations: configuration
        )
    }

    static func makeTrip(title: String = "Rome") -> Trip {
        Trip(
            title: title,
            startDate: Date(timeIntervalSince1970: 1_750_000_000),
            endDate: Date(timeIntervalSince1970: 1_750_500_000)
        )
    }
}
