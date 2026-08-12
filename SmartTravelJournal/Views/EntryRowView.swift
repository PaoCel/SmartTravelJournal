import SwiftUI
import SwiftData

struct EntryRowView: View {
    @Environment(\.modelContext) private var modelContext

    let entry: JournalEntry

    @ScaledMetric private var circleSize: CGFloat = 40
    @State private var tagViewModel = SmartTagViewModel()

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

                if tagViewModel.isGenerating {
                    ProgressView()
                        .controlSize(.mini)
                } else if !tagViewModel.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(tagViewModel.tags, id: \.self) { tag in
                                TagChipView(tag: tag)
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .task {
            await tagViewModel.generate(for: entry, context: modelContext)
        }
    }
}
