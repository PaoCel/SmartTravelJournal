import Foundation
import CoreLocation
import SwiftUI
import MapKit

extension JournalEntry {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Mood {
    var mapIcon: String {
        switch self {
        case .happy:   return "face.smiling"
        case .calm:    return "leaf"
        case .excited: return "star"
        case .sad:     return "cloud.rain"
        case .tired:   return "moon.zzz"
        }
    }

    var mapColor: Color {
        switch self {
        case .happy:   return .yellow
        case .calm:    return .green
        case .excited: return .orange
        case .sad:     return .blue
        case .tired:   return .purple
        }
    }
}

enum MapStyleOption: String, CaseIterable, Identifiable {
    case standard
    case imagery
    case hybrid

    var id: String { rawValue }

    var label: String {
        switch self {
        case .standard: return "Standard"
        case .imagery:  return "Satellite"
        case .hybrid:   return "Hybrid"
        }
    }

    var style: MapStyle {
        switch self {
        case .standard: return .standard
        case .imagery:  return .imagery
        case .hybrid:   return .hybrid
        }
    }
}
