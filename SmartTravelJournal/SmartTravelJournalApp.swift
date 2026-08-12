import SwiftUI
import SwiftData

@main
struct SmartTravelJournalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Trip.self, JournalEntry.self])
    }
}
