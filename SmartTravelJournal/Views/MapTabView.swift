import SwiftUI
import MapKit
import SwiftData
import UIKit

struct MapTabView: View {
    @Environment(LocationManager.self) private var locationManager
    @Environment(\.openURL) private var openURL

    @Query private var entries: [JournalEntry]

    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedMapStyle: MapStyleOption = .standard
    @State private var showsLocationDeniedAlert: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Map Style", selection: $selectedMapStyle) {
                    ForEach(MapStyleOption.allCases) { option in
                        Text(option.label).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                ZStack(alignment: .bottom) {
                    Map(position: $cameraPosition) {
                        ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                            if index == 0 {
                                Annotation(entry.title, coordinate: entry.coordinate) {
                                    EntryAnnotationView(entry: entry)
                                }
                            } else {
                                Marker(
                                    entry.title,
                                    systemImage: entry.mood.mapIcon,
                                    coordinate: entry.coordinate
                                )
                                .tint(entry.mood.mapColor)
                            }
                        }
                    }
                    .mapStyle(selectedMapStyle.style)
                    .overlay(alignment: .bottomTrailing) {
                        Button {
                            // Col permesso negato iOS non ripropone il dialogo:
                            // senza questo ramo il bottone non farebbe nulla.
                            guard !locationManager.isPermissionDenied else {
                                showsLocationDeniedAlert = true
                                return
                            }
                            locationManager.requestPermission()
                            locationManager.startUpdating()
                            withAnimation {
                                cameraPosition = .userLocation(fallback: .automatic)
                            }
                        } label: {
                            Image(systemName: "location.circle.fill")
                                .font(.title2)
                                .padding(10)
                                .background(.thinMaterial)
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Center on my location")
                        .accessibilityHint("Moves the map to your current position")
                        .padding(.trailing)
                        .padding(.bottom, 90)
                    }

                    MapSummaryCard(entryCount: entries.count)
                }
            }
            .navigationTitle("Map")
            .alert("Location access is off", isPresented: $showsLocationDeniedAlert) {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    Button("Open Settings") { openURL(settingsURL) }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Allow location access in Settings to center the map on your position.")
            }
        }
    }
}
