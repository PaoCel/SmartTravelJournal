import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(TripsViewModel.self) private var tripsViewModel
    @Environment(JournalEntryViewModel.self) private var journalEntryViewModel
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Trip.startDate, order: .reverse)
    private var trips: [Trip]

    var body: some View {
        NavigationStack {
            List {
                Section("Trips (\(trips.count))") {
                    ForEach(tripsViewModel.filteredTrips(trips)) { trip in
                        VStack(alignment: .leading) {
                            Text(trip.title).font(.headline)
                            Text("\(trip.entries.count) entries")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete { offsets in
                        tripsViewModel.deleteTrips(at: offsets, from: trips, context: modelContext)
                    }
                }
            }
            .navigationTitle("Smart Travel Journal")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Sample") {
                        tripsViewModel.addTrip(
                            title: "Summer in Lisbon",
                            startDate: .now,
                            endDate: Calendar.current.date(byAdding: .day, value: 7, to: .now) ?? .now,
                            context: modelContext
                        )
                    }
                }
            }
        }
    }
}

// Temporary binding test — safe to delete before next lab
private struct BindingTestView: View {
    @Environment(JournalEntryViewModel.self) private var entryViewModel

    var body: some View {
        @Bindable var vm = entryViewModel

        VStack(spacing: 16) {
            // Title binding — same pattern used in the entry editor TextField
            TextField("Entry title", text: $vm.title)
                .textFieldStyle(.roundedBorder)

            // Mood binding — same pattern used in the mood button row
            Picker("Mood", selection: $vm.mood) {
                ForEach(Mood.allCases) { mood in
                    Text(mood.label).tag(mood)
                }
            }
            .pickerStyle(.segmented)

            // Image name binding — same pattern used in the LazyVGrid image picker
            TextField("Image name", text: $vm.imageName)
                .textFieldStyle(.roundedBorder)

            Text("title: \(vm.title) | mood: \(vm.mood.label) | image: \(vm.imageName)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Trip.self, JournalEntry.self, configurations: config)

    return ContentView()
        .modelContainer(container)
        .environment(TripsViewModel())
        .environment(JournalEntryViewModel())
}
