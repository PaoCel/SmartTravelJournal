import Foundation
import FoundationModels

@Generable
struct TripSummary {
    @Guide(description: "A summary of the trip in up to 3 sentences.")
    var summary: String

    @Guide(description: "A list of up to 3 short highlight phrases from the trip.")
    var highlights: [String]
}
