import SwiftUI
import SwiftData
import Charts

struct ChartsTabView: View {
    @Query private var trips: [Trip]
    @Query(sort: \JournalEntry.timestamp) private var entries: [JournalEntry]

    private var sortedEntries: [JournalEntry] {
        entries.sorted { $0.timestamp < $1.timestamp }
    }

    private var topMoodEmoji: String {
        let counts = sortedEntries.reduce(into: [Mood: Int]()) { result, entry in
            result[entry.mood, default: 0] += 1
        }
        return counts.max { $0.value < $1.value }?.key.emoji ?? "—"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if trips.isEmpty && sortedEntries.isEmpty {
                        ContentUnavailableView(
                            "No Data Yet",
                            systemImage: "chart.bar",
                            description: Text("Add a trip and a few journal entries to see your travel statistics here.")
                        )
                        .padding(.top, 60)
                    } else {
                        if !sortedEntries.isEmpty {
                            entriesOverTimeChart
                            moodTrendsChart
                        }

                        HStack(spacing: 12) {
                            StatCard(title: "Total Entries", color: .blue) {
                                Text("\(sortedEntries.count)")
                                    .contentTransition(.numericText())
                            }
                            StatCard(title: "Total Trips", color: .green) {
                                Text("\(trips.count)")
                                    .contentTransition(.numericText())
                            }
                            StatCard(title: "Top Mood", color: .purple) {
                                Text(topMoodEmoji)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Charts")
        }
    }

    private var entriesOverTimeChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Entries over Time")
                .font(.headline)

            Chart {
                ForEach(Array(sortedEntries.enumerated()), id: \.element.id) { index, entry in
                    LineMark(
                        x: .value("Date", entry.timestamp),
                        y: .value("Entry", index + 1)
                    )
                    .foregroundStyle(.blue)

                    AreaMark(
                        x: .value("Date", entry.timestamp),
                        y: .value("Entry", index + 1)
                    )
                    .foregroundStyle(.blue.opacity(0.15))
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic)
            }
        }
    }

    private var moodTrendsChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Mood Trends")
                .font(.headline)

            Chart {
                ForEach(sortedEntries) { entry in
                    LineMark(
                        x: .value("Date", entry.timestamp),
                        y: .value("Mood", entry.mood.numericValue)
                    )
                    .foregroundStyle(.orange)
                    .interpolationMethod(.catmullRom)

                    AreaMark(
                        x: .value("Date", entry.timestamp),
                        y: .value("Mood", entry.mood.numericValue)
                    )
                    .foregroundStyle(.orange.opacity(0.15))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
            .chartYAxis {
                AxisMarks(values: [1, 2, 3, 4, 5]) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let raw = value.as(Int.self),
                           let mood = Mood.allCases.first(where: { $0.numericValue == raw }) {
                            Text(mood.emoji)
                        }
                    }
                }
            }
        }
    }
}
