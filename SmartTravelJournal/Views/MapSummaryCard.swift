import SwiftUI

struct MapSummaryCard: View {
    let entryCount: Int

    var body: some View {
        HStack {
            Image(systemName: "map.circle.fill")
                .foregroundStyle(.blue)

            Text(entryCount == 1 ? "1 entry on map" : "\(entryCount) entries on map")

            Spacer()
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding()
    }
}
