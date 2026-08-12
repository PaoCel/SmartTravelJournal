import Foundation
import SwiftData

@MainActor
@Observable
final class TripsViewModel {
    var searchText: String = ""
    var selectedTrip: Trip? = nil

    // Search

    func filteredTrips(_ trips: [Trip]) -> [Trip] {
        if searchText.isEmpty { return trips }
        return trips.filter {
            $0.title.localizedStandardContains(searchText)
        }
    }

    // CRUD

    func addTrip(
        title: String,
        startDate: Date,
        endDate: Date,
        coverImageName: String = "trip_beach",
        context: ModelContext
    ) {
        let trip = Trip(
            title: title,
            startDate: startDate,
            endDate: endDate,
            coverImageName: coverImageName
        )
        context.insert(trip)
    }

    func updateTrip(_ trip: Trip, title: String, startDate: Date, endDate: Date) {
        trip.title = title
        trip.startDate = startDate
        trip.endDate = endDate
    }

    func deleteTrip(_ trip: Trip, context: ModelContext) {
        context.delete(trip)
    }

    func deleteTrips(at offsets: IndexSet, from trips: [Trip], context: ModelContext) {
        for index in offsets {
            context.delete(trips[index])
        }
    }
}
