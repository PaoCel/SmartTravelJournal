import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TripListView()
                .tabItem {
                    Label("Trips", systemImage: "suitcase.fill")
                }

            MapTabView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }

            ChartsTabView()
                .tabItem {
                    Label("Charts", systemImage: "chart.bar.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
