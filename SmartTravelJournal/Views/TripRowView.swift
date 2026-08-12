import SwiftUI

struct TripRowView: View {
    let trip: Trip

    var body: some View {
        HStack(spacing: 12) {
            Image(trip.coverImageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(trip.title)
                    .font(.headline)

                Text(dateRange)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("\(trip.entries.count) entries")
                    .font(.caption2)
                    .foregroundStyle(Color.accentColor)
            }
        }
    }

    private var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "\(formatter.string(from: trip.startDate)) – \(formatter.string(from: trip.endDate))"
    }
}
