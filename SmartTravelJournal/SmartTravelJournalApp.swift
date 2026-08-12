import SwiftUI
import SwiftData

@main
struct SmartTravelJournalApp: App {
    @State private var tripsViewModel = TripsViewModel()
    @State private var journalEntryViewModel = JournalEntryViewModel()
    @State private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(tripsViewModel)
                .environment(journalEntryViewModel)
                .environment(locationManager)
        }
        .modelContainer(for: [Trip.self, JournalEntry.self])
    }
}
