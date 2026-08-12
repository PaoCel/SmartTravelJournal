import Foundation

enum APIError: Error, LocalizedError {
    case missingAPIKey
    case networkUnavailable
    case invalidResponse
    case decodingFailed
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Add an OpenWeatherMap API key in Build Settings to load weather."
        case .networkUnavailable:
            return "No internet connection. Please check your network."
        case .invalidResponse:
            return "Unexpected response from the server."
        case .decodingFailed:
            return "Could not read the weather data."
        case .serverError(let code):
            return "Server error (\(code))."
        }
    }
}
