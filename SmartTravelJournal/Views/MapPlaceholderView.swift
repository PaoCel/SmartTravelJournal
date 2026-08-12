import SwiftUI

struct MapPlaceholderView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Map Coming Soon",
                systemImage: "map",
                description: Text("Your journal entries will appear here on an interactive map in a future exercise.")
            )
            .navigationTitle("Map")
        }
    }
}
