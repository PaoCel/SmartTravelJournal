import XCTest
@testable import SmartTravelJournal

final class WeatherResponseDecodingTests: XCTestCase {
    func testDecodesOpenWeatherMapPayloadAndRejectsMissingMainBlock() throws {
        let payload = """
        {
          "name": "Rome",
          "main": { "temp": 27.4, "feels_like": 29.1, "humidity": 48 },
          "weather": [ { "description": "clear sky", "icon": "01d" } ]
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(WeatherResponse.self, from: payload)
        XCTAssertEqual(response.name, "Rome")
        XCTAssertEqual(response.main.temp, 27.4, accuracy: 0.001)
        XCTAssertEqual(response.main.feelsLike, 29.1, accuracy: 0.001, "feels_like → feelsLike via CodingKeys")
        XCTAssertEqual(response.main.humidity, 48)
        XCTAssertEqual(response.weather.first?.description, "clear sky")
        XCTAssertEqual(response.weather.first?.icon, "01d")

        let broken = """
        { "name": "Rome", "weather": [] }
        """.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(WeatherResponse.self, from: broken))
    }
}
