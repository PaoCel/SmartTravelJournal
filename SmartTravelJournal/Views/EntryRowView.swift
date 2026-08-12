import SwiftUI

struct EntryRowView: View {
    let entry: JournalEntry

    @ScaledMetric private var circleSize: CGFloat = 40

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: circleSize, height: circleSize)

                Text(entry.mood.emoji)
                    .font(.title3)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(entry.title)
                        .font(.headline)

                    Spacer()

                    Text(entry.timestamp, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(entry.timestamp, format: .dateTime.hour().minute())
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(entry.body)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text("AI tags will appear here.")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}
