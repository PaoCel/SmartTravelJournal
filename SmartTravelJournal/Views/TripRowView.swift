import SwiftUI

struct TripRowView: View {
    let trip: Trip
    let namespace: Namespace.ID

    @ScaledMetric private var imageSize: CGFloat = 60

    var body: some View {
        HStack(spacing: 12) {
            Image(trip.coverImageName)
                .resizable()
                .scaledToFill()
                .frame(width: imageSize, height: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .matchedGeometryEffect(id: trip.id, in: namespace)

            VStack(alignment: .leading, spacing: 4) {
                Text(trip.title)
                    .font(.headline)

                Text(dateRange)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("\(trip.entries.count) entries")
                    .font(.caption2)
                    .foregroundStyle(.tint)
                    .contentTransition(.numericText())
            }
        }
    }

    private var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "\(formatter.string(from: trip.startDate)) – \(formatter.string(from: trip.endDate))"
    }
}
