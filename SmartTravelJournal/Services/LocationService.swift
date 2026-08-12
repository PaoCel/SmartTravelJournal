import Foundation
import CoreLocation

final class LocationService {
    /// ⚠️ Sostituire con la propria chiave OpenWeatherMap (openweathermap.org/api).
    /// Finché resta il placeholder l'API risponde 401 e la UI mostra lo stato d'errore
    /// con il pulsante Retry — che è comunque uno dei punti di verifica del lab.
    private let apiKey = "YOUR_API_KEY_HERE"

    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for coordinate: CLLocationCoordinate2D) async throws -> WeatherResponse {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
            URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
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
