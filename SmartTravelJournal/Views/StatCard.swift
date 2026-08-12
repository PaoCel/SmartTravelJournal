import SwiftUI

struct StatCard<Content: View>: View {
    let title: LocalizedStringKey
    let color: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)

            content
                .font(.title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .foregroundStyle(.white)
    }
}
