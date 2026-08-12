import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TripListView()
                .tabItem {
                    Label("Trips", systemImage: "suitcase.fill")
                }

            MapPlaceholderView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }

            ChartsPlaceholderView()
                .tabItem {
                    Label("Charts", systemImage: "chart.bar.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
