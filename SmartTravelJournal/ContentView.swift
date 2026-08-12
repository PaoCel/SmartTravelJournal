import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context

    @Query(sort: \Trip.startDate, order: .reverse)
    private var trips: [Trip]

    @Query(
        filter: #Predicate<Trip> { trip in
            trip.title.localizedStandardContains("summer")
        },
        sort: [SortDescriptor(\Trip.title, order: .forward)]
    )
    private var summerTrips: [Trip]

    var body: some View {
        NavigationStack {
            List {
                Section("Trips (\(trips.count))") {
                    ForEach(trips) { trip in
                        VStack(alignment: .leading) {
                            Text(trip.title).font(.headline)
                            Text("\(trip.entries.count) entries")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Summer trips (\(summerTrips.count))") {
                    ForEach(summerTrips) { trip in
                        Text(trip.title)
                    }
                }
            }
            .navigationTitle("Data Layer Check")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Add Sample") { addSampleTrip() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Update First") { updateFirstTrip() }
                        Button("Delete All", role: .destructive) {
                            deleteAllTrips()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }

    private func addSampleTrip() {
        let trip = Trip(
            title: "Summer in Lisbon",
            startDate: .now,
            endDate: Calendar.current.date(
                byAdding: .day, value: 7, to: .now
            ) ?? .now,
            coverImageName: "trip_beach"
        )
        let entry = JournalEntry(
            title: "Day 1 in Alfama",
            body: "Wandered the narrow streets and listened to fado.",
            mood: .happy,
            latitude: 38.7139,
            longitude: -9.1334
        )
        trip.entries.append(entry)
        context.insert(trip)
    }

    private func updateFirstTrip() {
        guard let first = trips.first else { return }
        first.title = first.title + " (edited)"
    }

    private func deleteAllTrips() {
        for trip in trips {
            context.delete(trip)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Trip.self, JournalEntry.self], inMemory: true)
}
