import SwiftUI
import SwiftData

struct TripDetailView: View {
    @Environment(JournalEntryViewModel.self) private var entryViewModel
    @Environment(\.modelContext) private var modelContext

    let trip: Trip

    @State private var showAddEntry = false

    private var sortedEntries: [JournalEntry] {
        trip.entries.sorted { $0.timestamp < $1.timestamp }
    }

    var body: some View {
        Form {
            Section("Trip Info") {
                LabeledContent("Dates", value: dateRange)
                LabeledContent("Entries", value: "\(trip.entries.count)")
            }

            Section {
                Text("AI-generated trip summary will appear here.")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }

            Section("JOURNAL ENTRIES") {
                if sortedEntries.isEmpty {
                    Text("No entries yet. Tap + Add Entry to create one.")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                } else {
                    ForEach(sortedEntries) { entry in
                        EntryRowView(entry: entry)
                    }
                    .onDelete { offsets in
                        for index in offsets {
                            entryViewModel.deleteEntry(
                                sortedEntries[index],
                                context: modelContext
                            )
                        }
                    }
                }
            }

            Section {
                Button {
                    showAddEntry = true
                } label: {
                    Text("+ Add Entry")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue.opacity(0.7))
            }
        }
        .navigationTitle(trip.title)
        .navigationSubtitle("\(dateRange) · \(trip.entries.count) entries")
        .sheet(isPresented: $showAddEntry) {
            JournalEntryEditor(trip: trip)
        }
    }

    private var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "\(formatter.string(from: trip.startDate)) – \(formatter.string(from: trip.endDate))"
    }
}
