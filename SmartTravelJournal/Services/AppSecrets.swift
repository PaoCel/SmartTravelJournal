import Foundation

/// La chiave sta in `INFOPLIST_KEY_OpenWeatherMapAPIKey` (Build Settings) e finisce
/// nell'Info.plist generato: così il progetto si apre e compila senza file mancanti,
/// e nessuna chiave vera resta nel codice sorgente.
/// Istruzioni per inserirla: README.md
enum AppSecrets {
    static let placeholder = "YOUR_API_KEY_HERE"

    static var openWeatherMapAPIKey: String {
        Bundle.main.object(forInfoDictionaryKey: "OpenWeatherMapAPIKey") as? String ?? ""
    }

    /// `true` finché nessuno ha sostituito il segnaposto.
    static var isOpenWeatherMapKeyMissing: Bool {
        let key = openWeatherMapAPIKey
        return key.isEmpty || key == placeholder
    }
}
