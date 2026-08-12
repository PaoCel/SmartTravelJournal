import Foundation

extension Mood {
    /// Valore numerico per l'asse Y del grafico Mood Trends.
    /// L'ordine va dal mood più basso al più alto.
    var numericValue: Int {
        switch self {
        case .tired:   return 1
        case .sad:     return 2
        case .calm:    return 3
        case .happy:   return 4
        case .excited: return 5
        }
    }
}
