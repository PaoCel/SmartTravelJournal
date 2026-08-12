import SwiftUI
import SwiftData

struct AddTripView: View {
    @Environment(TripsViewModel.self) private var tripsViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    /// Se valorizzato la sheet modifica il viaggio invece di crearne uno nuovo.
    var tripToEdit: Trip? = nil

    @State private var title = ""
    @State private var startDate = Date.now
    @State private var endDate = Calendar.current.date(
        byAdding: .day, value: 7, to: .now
    ) ?? .now

    var body: some View {
        NavigationStack {
            Form {
                Section("Trip Details") {
                    TextField("Title", text: $title)

                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        displayedComponents: .date
                    )

                    DatePicker(
                        "End Date",
                        selection: $endDate,
                        displayedComponents: .date
                    )
                }
            }
            .navigationTitle(tripToEdit == nil ? "New Trip" : "Edit Trip")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                guard let trip = tripToEdit else { return }
                title = trip.title
                startDate = trip.startDate
                endDate = trip.endDate
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if let trip = tripToEdit {
                            tripsViewModel.updateTrip(
                                trip,
                                title: title,
                                startDate: startDate,
                                endDate: endDate
                            )
                        } else {
                            tripsViewModel.addTrip(
                                title: title,
                                startDate: startDate,
                                endDate: endDate,
                                context: modelContext
                            )
                        }
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
