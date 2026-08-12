import SwiftUI

struct ChartsPlaceholderView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Charts Coming Soon",
                systemImage: "chart.bar",
                description: Text("Statistics about your trips will be visualised here in a future exercise.")
            )
            .navigationTitle("Charts")
        }
    }
}
