import SwiftUI
import SwiftData

struct AddTripView: View {
    @Environment(TripsViewModel.self) private var tripsViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

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
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        tripsViewModel.addTrip(
                            title: title,
                            startDate: startDate,
                            endDate: endDate,
                            context: modelContext
                        )
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
