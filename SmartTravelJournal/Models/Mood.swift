import Foundation

enum Mood: String, CaseIterable, Codable, Identifiable {
    case happy
    case calm
    case excited
    case sad
    case tired

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .happy:   return "😀"
        case .calm:    return "🙂"
        case .excited: return "🤩"
        case .sad:     return "😔"
        case .tired:   return "😴"
        }
    }

    var label: String {
        switch self {
        case .happy:   return "Happy"
        case .calm:    return "Calm"
        case .excited: return "Excited"
        case .sad:     return "Sad"
        case .tired:   return "Tired"
        }
    }
}
