import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [WeatherCondition]

    struct MainWeather: Codable {
        let temp: Double
        let feelsLike: Double
        let humidity: Int

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case humidity
        }
    }

    struct WeatherCondition: Codable {
        let description: String
        let icon: String
    }
}
