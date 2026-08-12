import SwiftUI
import SwiftData
import CoreLocation
import UIKit

struct JournalEntryEditor: View {
    @Environment(JournalEntryViewModel.self) private var entryViewModel
    @Environment(LocationManager.self) private var locationManager
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    let trip: Trip
    /// Se valorizzata la sheet modifica la entry invece di crearne una nuova.
    var entryToEdit: JournalEntry? = nil

    @State private var weatherText: String = ""
    @State private var isLoadingWeather: Bool = false
    @State private var weatherError: String? = nil

    private let locationService = LocationService()

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
                    if let coordinate = locationManager.currentCoordinate {
                        LabeledContent(
                            "Latitude",
                            value: coordinate.latitude.formatted(.number.precision(.fractionLength(4)))
                        )
                        LabeledContent(
                            "Longitude",
                            value: coordinate.longitude.formatted(.number.precision(.fractionLength(4)))
                        )
                    } else if locationManager.isPermissionDenied {
                        // Un solo messaggio, con la via d'uscita. Il permesso non
                        // si richiede una seconda volta: iOS non lo mostrerebbe.
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location access is off. The entry will be saved without a place.")
                                .foregroundStyle(.secondary)
                                .font(.caption)

                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                Button("Open Settings") {
                                    openURL(settingsURL)
                                }
                                .accessibilityHint("Opens the Settings app to allow location access")
                            }
                        }
                    } else {
                        Text("Detecting location…")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }

                Section("Weather at Location") {
                    if isLoadingWeather {
                        HStack {
                            ProgressView()
                            Text("Fetching weather…")
                                .foregroundStyle(.secondary)
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    } else if let weatherError {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(weatherError)
                                .foregroundStyle(.red)
                                .font(.caption)

                            Button("Retry") {
                                Task { await fetchWeather() }
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    } else if !weatherText.isEmpty {
                        Text(weatherText)
                            .font(.subheadline)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    } else if locationManager.isPermissionDenied {
                        Text("Weather is unavailable without location access.")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    } else {
                        Text("Weather will load once your location is available.")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: isLoadingWeather)

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
                            .accessibilityLabel(mood.label)
                            .accessibilityHint("Sets the mood for this entry")
                            .accessibilityAddTraits(vm.mood == mood ? .isSelected : [])
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
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(imageLabels[index])
                            .accessibilityHint("Sets the photo for this entry")
                            .accessibilityAddTraits(vm.imageName == name ? .isSelected : [])
                        }
                    }
                }

                Section(footer: Text("Entry will be timestamped automatically")) {
                    EmptyView()
                }
            }
            .navigationTitle(entryToEdit == nil ? "New Entry" : "Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let entry = entryToEdit {
                    entryViewModel.load(from: entry)
                    return
                }
                // Il ViewModel è condiviso: senza reset una bozza annullata (o la
                // entry aperta in modifica) resterebbe nella prossima nuova entry.
                entryViewModel.resetForm()
                locationManager.requestPermission()
                if let coordinate = locationManager.currentCoordinate {
                    entryViewModel.latitude = coordinate.latitude
                    entryViewModel.longitude = coordinate.longitude
                    Task { await fetchWeather() }
                }
            }
            .onChange(of: locationManager.currentCoordinate?.latitude) { _, newValue in
                guard newValue != nil else { return }
                if let coordinate = locationManager.currentCoordinate {
                    entryViewModel.latitude = coordinate.latitude
                    entryViewModel.longitude = coordinate.longitude
                }
                Task { await fetchWeather() }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        entryViewModel.resetForm()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if let entry = entryToEdit {
                            entryViewModel.updateEntry(entry, context: modelContext)
                        } else {
                            entryViewModel.saveEntry(to: trip, context: modelContext)
                        }
                        dismiss()
                    }
                    .disabled(!entryViewModel.isFormValid)
                }
            }
        }
    }

    private func fetchWeather() async {
        guard let coordinate = locationManager.currentCoordinate else { return }

        isLoadingWeather = true
        weatherError = nil

        do {
            let weather = try await locationService.fetchWeather(for: coordinate)
            // L'API risponde in Celsius; Measurement lo converte nell'unità
            // preferita dal locale (°F negli USA) senza toccare la richiesta.
            let temperature = Measurement(value: weather.main.temp, unit: UnitTemperature.celsius)
            let temp = temperature.formatted(.measurement(width: .abbreviated, usage: .weather))
            let condition = weather.weather.first?.description ?? ""
            weatherText = "\(weather.name) · \(temp) · \(condition)"
        } catch let error as APIError {
            weatherError = error.errorDescription
        } catch {
            weatherError = APIError.networkUnavailable.errorDescription
        }

        isLoadingWeather = false
    }
}
