import SwiftUI
import MapKit
import SwiftData

struct MapTabView: View {
    @Environment(LocationManager.self) private var locationManager

    @Query private var entries: [JournalEntry]

    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedMapStyle: MapStyleOption = .standard

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
                        .padding(.trailing)
                        .padding(.bottom, 90)
                    }

                    MapSummaryCard(entryCount: entries.count)
                }
            }
            .navigationTitle("Map")
        }
    }
}
