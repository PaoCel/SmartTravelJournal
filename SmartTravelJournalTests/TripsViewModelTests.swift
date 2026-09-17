import XCTest
import SwiftData
@testable import SmartTravelJournal

@MainActor
final class TripsViewModelTests: XCTestCase {
    private var container: ModelContainer!
    private var context: ModelContext!
    private var viewModel: TripsViewModel!

    override func setUp() async throws {
        container = try TestSupport.makeContainer()
        context = ModelContext(container)
        viewModel = TripsViewModel()
    }

    func testFilteredTripsIsCaseInsensitiveAndEmptySearchReturnsAll() {
        let trips = [
            TestSupport.makeTrip(title: "Rome in Spring"),
            TestSupport.makeTrip(title: "Tokyo Nights"),
            TestSupport.makeTrip(title: "Weekend in Roma")
        ]

        viewModel.searchText = ""
        XCTAssertEqual(viewModel.filteredTrips(trips).count, 3)

        viewModel.searchText = "rom"
        XCTAssertEqual(
            viewModel.filteredTrips(trips).map(\.title),
            ["Rome in Spring", "Weekend in Roma"]
        )

        viewModel.searchText = "paris"
        XCTAssertTrue(viewModel.filteredTrips(trips).isEmpty)
    }

    func testAddTripPersistsAndDeleteTripsRemovesOnlySelectedOffsets() throws {
        viewModel.addTrip(title: "Rome", startDate: .now, endDate: .now, context: context)
        viewModel.addTrip(title: "Tokyo", startDate: .now, endDate: .now, context: context)
        viewModel.addTrip(title: "Lisbon", startDate: .now, endDate: .now, context: context)
        try context.save()

        let sortByTitle = FetchDescriptor<Trip>(sortBy: [SortDescriptor(\.title)])
        var trips = try context.fetch(sortByTitle)
        XCTAssertEqual(trips.map(\.title), ["Lisbon", "Rome", "Tokyo"])

        viewModel.deleteTrips(at: IndexSet([0, 2]), from: trips, context: context)
        try context.save()

        trips = try context.fetch(sortByTitle)
        XCTAssertEqual(trips.map(\.title), ["Rome"])
    }
}
