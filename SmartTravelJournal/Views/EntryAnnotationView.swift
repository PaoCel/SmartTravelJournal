import SwiftUI

struct EntryAnnotationView: View {
    let entry: JournalEntry

    var body: some View {
        VStack(spacing: 2) {
            Text(entry.mood.emoji)
                .font(.title2)

            VStack(spacing: 2) {
                Text(entry.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text(entry.timestamp, style: .date)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(6)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Image(systemName: "triangle.fill")
                .font(.caption2)
                .foregroundStyle(.regularMaterial)
                .rotationEffect(.degrees(180))
                .offset(y: -4)
        }
    }
}
