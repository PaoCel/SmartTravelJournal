import SwiftUI
import SwiftData

@main
struct SmartTravelJournalApp: App {
    @State private var tripsViewModel = TripsViewModel()
    @State private var journalEntryViewModel = JournalEntryViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(tripsViewModel)
                .environment(journalEntryViewModel)
        }
        .modelContainer(for: [Trip.self, JournalEntry.self])
    }
}
