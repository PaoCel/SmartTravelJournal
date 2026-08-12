import SwiftUI
import SwiftData

struct TripDetailView: View {
    @Environment(JournalEntryViewModel.self) private var entryViewModel
    @Environment(\.modelContext) private var modelContext

    let trip: Trip
    let namespace: Namespace.ID

    @State private var showAddEntry = false
    @State private var showEditTrip = false
    @State private var entryToEdit: JournalEntry? = nil
    @State private var appeared = false
    @State private var summaryViewModel = TripSummaryViewModel()

    private var sortedEntries: [JournalEntry] {
        entryViewModel.filteredEntries(
            trip.entries.sorted { $0.timestamp < $1.timestamp }
        )
    }

    var body: some View {
        @Bindable var vm = entryViewModel

        List {
            Section {
                Image(trip.coverImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .matchedGeometryEffect(id: trip.id, in: namespace)
                    .listRowInsets(EdgeInsets())
                    .accessibilityLabel("Cover photo for \(trip.title)")
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
                    Text(
                        entryViewModel.searchText.isEmpty
                            ? "No entries yet. Tap + Add Entry to create one."
                            : "No entries match your search."
                    )
                    .foregroundStyle(.secondary)
                    .font(.caption)
                } else {
                    ForEach(Array(sortedEntries.enumerated()), id: \.element.id) { index, entry in
                        EntryRowView(entry: entry)
                            .contentShape(Rectangle())
                            .onTapGesture { entryToEdit = entry }
                            .accessibilityHint("Double tap to edit this entry")
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
        .searchable(text: $vm.searchText, prompt: "Search entries")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { showEditTrip = true }
                    .accessibilityHint("Edit this trip's title and dates")
            }
        }
        .onAppear {
            // Il ViewModel è condiviso fra i viaggi: la ricerca non deve
            // sopravvivere all'uscita da questo dettaglio.
            entryViewModel.searchText = ""
            appeared = false
            Task {
                try? await Task.sleep(for: .milliseconds(100))
                withAnimation {
                    appeared = true
                }
            }
        }
        // `id:` fa ripartire il task quando cambia il numero di entry: senza,
        // dopo la prima entry la card resterebbe su "Add journal entries…".
        .task(id: trip.entries.count) {
            await summaryViewModel.generate(for: trip, context: modelContext)
        }
        .sheet(isPresented: $showAddEntry) {
            JournalEntryEditor(trip: trip)
        }
        .sheet(isPresented: $showEditTrip) {
            AddTripView(tripToEdit: trip)
        }
        .sheet(item: $entryToEdit) { entry in
            JournalEntryEditor(trip: trip, entryToEdit: entry)
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
