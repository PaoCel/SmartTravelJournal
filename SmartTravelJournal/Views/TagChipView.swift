import SwiftUI

struct TagChipView: View {
    let tag: String

    var body: some View {
        Text(tag)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(chipColor.opacity(0.2))
            .foregroundStyle(chipColor)
            .clipShape(Capsule())
    }

    private var chipColor: Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .teal]
        let index = abs(tag.hashValue) % colors.count
        return colors[index]
    }
}
