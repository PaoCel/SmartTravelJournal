import Foundation

enum APIError: Error, LocalizedError {
    case networkUnavailable
    case invalidResponse
    case decodingFailed
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "No internet connection. Check your network and try again."
        case .invalidResponse:
            return "Unexpected response from the server."
        case .decodingFailed:
            return "Could not read the weather data."
        case .serverError(let code):
            return "Server error (\(code))."
        }
    }
}
