import Foundation

enum AIError: Error, LocalizedError {
    case unavailable(String)
    case generationFailed(String)

    var errorDescription: String? {
        switch self {
        case .unavailable:
            return "AI features require Apple Intelligence. Please enable Apple Intelligence in Settings."
        case .generationFailed(let message):
            return "Generation failed: \(message)"
        }
    }
}
