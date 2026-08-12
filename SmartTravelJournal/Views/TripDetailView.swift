import SwiftUI
import SwiftData

struct TripDetailView: View {
    @Environment(JournalEntryViewModel.self) private var entryViewModel
    @Environment(\.modelContext) private var modelContext

    let trip: Trip
    let namespace: Namespace.ID

    @State private var showAddEntry = false
    @State private var appeared = false
    @State private var summaryViewModel = TripSummaryViewModel()

    private var sortedEntries: [JournalEntry] {
        trip.entries.sorted { $0.timestamp < $1.timestamp }
    }

    var body: some View {
        List {
            Section {
                Image(trip.coverImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .matchedGeometryEffect(id: trip.id, in: namespace)
                    .listRowInsets(EdgeInsets())
            }

            Section("Trip Info") {
                LabeledContent("Dates", value: dateRange)
                LabeledContent("Entries", value: "\(trip.entries.count)")
                    .contentTransition(.numericText())
            }

            Section {
                AISummaryCard(viewModel: summaryViewModel, trip: trip)
            }

            Section("JOURNAL ENTRIES") {
                if sortedEntries.isEmpty {
                    Text("No entries yet. Tap + Add Entry to create one.")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                } else {
                    ForEach(Array(sortedEntries.enumerated()), id: \.element.id) { index, entry in
                        EntryRowView(entry: entry)
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 20)
                            .animation(
                                .spring(duration: 1.2, bounce: 0.25)
                                    .delay(Double(index) * 0.18),
                                value: appeared
                            )
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
                    withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                        showAddEntry = true
                    }
                } label: {
                    Text("+ Add Entry")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue.opacity(0.7))
            }
        }
        .navigationTitle(trip.title)
        .navigationSubtitle("\(dateRange) · \(entriesLabel)")
        .onAppear {
            appeared = false
            Task {
                try? await Task.sleep(for: .milliseconds(100))
                withAnimation {
                    appeared = true
                }
            }
        }
        .task {
            await summaryViewModel.generate(for: trip, context: modelContext)
        }
        .sheet(isPresented: $showAddEntry) {
            JournalEntryEditor(trip: trip)
        }
    }

    private var entriesLabel: String {
        String(localized: "\(trip.entries.count) entries")
    }

    private var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "\(formatter.string(from: trip.startDate)) – \(formatter.string(from: trip.endDate))"
    }
}
