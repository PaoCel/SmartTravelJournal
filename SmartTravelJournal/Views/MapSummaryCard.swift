import SwiftUI

struct MapSummaryCard: View {
    let entryCount: Int

    var body: some View {
        HStack {
            Image(systemName: "map.circle.fill")
                .foregroundStyle(.blue)

            Text("\(entryCount) entries on map")

            Spacer()
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding()
    }
}
