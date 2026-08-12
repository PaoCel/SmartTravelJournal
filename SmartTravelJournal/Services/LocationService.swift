import Foundation
import CoreLocation

final class LocationService: Sendable {
    /// La chiave arriva dai Build Settings via Info.plist: vedi `AppSecrets`.
    private let apiKey = AppSecrets.openWeatherMapAPIKey

    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for coordinate: CLLocationCoordinate2D) async throws -> WeatherResponse {
        guard !AppSecrets.isOpenWeatherMapKeyMissing else {
            throw APIError.missingAPIKey
        }

        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
            URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: Locale.current.language.languageCode?.identifier ?? "en")
        ]

        guard let url = components?.url else {
            throw APIError.invalidResponse
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw APIError.networkUnavailable
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard http.statusCode == 200 else {
            throw APIError.serverError(http.statusCode)
        }

        do {
            return try JSONDecoder().decode(WeatherResponse.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
}
