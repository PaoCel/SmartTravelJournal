import SwiftUI
import SwiftData

struct JournalEntryEditor: View {
    @Environment(JournalEntryViewModel.self) private var entryViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let trip: Trip

    private let imageNames = ["trip_beach", "trip_mountain", "trip_city", "trip_forest", "trip_desert"]
    private let imageLabels = ["Beach", "Mountain", "City", "Forest", "Desert"]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        @Bindable var vm = entryViewModel

        NavigationStack {
            Form {
                Section("Entry Details") {
                    TextField("Title", text: $vm.title)

                    TextField("Body", text: $vm.body, axis: .vertical)
                        .lineLimit(4...8)

                    DatePicker(
                        "Date",
                        selection: $vm.timestamp,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }

                Section("Location") {
                    Text("Location will be detected automatically.")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }

                Section("Mood") {
                    HStack {
                        ForEach(Mood.allCases) { mood in
                            Button {
                                vm.mood = mood
                            } label: {
                                VStack(spacing: 4) {
                                    Text(mood.emoji)
                                        .font(.title2)
                                    Text(mood.label)
                                        .font(.caption2)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(
                                    vm.mood == mood ? Color.accentColor.opacity(0.2) : Color.clear
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section("Travel Image") {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(Array(imageNames.enumerated()), id: \.offset) { index, name in
                            VStack(spacing: 4) {
                                Image(name)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                vm.imageName == name ? Color.accentColor : Color.clear,
                                                lineWidth: 3
                                            )
                                    }

                                Text(imageLabels[index])
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .onTapGesture {
                                vm.imageName = name
                            }
                        }
                    }
                }

                Section(footer: Text("Entry will be timestamped automatically")) {
                    EmptyView()
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        entryViewModel.saveEntry(to: trip, context: modelContext)
                        dismiss()
                    }
                    .disabled(!entryViewModel.isFormValid)
                }
            }
        }
    }
}
