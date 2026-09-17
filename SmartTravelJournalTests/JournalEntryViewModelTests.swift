import XCTest
import SwiftData
@testable import SmartTravelJournal

@MainActor
final class JournalEntryViewModelTests: XCTestCase {
    private var container: ModelContainer!
    private var context: ModelContext!
    private var viewModel: JournalEntryViewModel!

    override func setUp() async throws {
        container = try TestSupport.makeContainer()
        context = ModelContext(container)
        viewModel = JournalEntryViewModel()
    }

    func testSaveEntryAppendsToTripInvalidatesCachedSummaryAndResetsForm() throws {
        let trip = TestSupport.makeTrip()
        trip.aiSummary = "Old summary"
        trip.aiHighlightsCSV = "old, stale"
        context.insert(trip)

        viewModel.title = "   "
        XCTAssertFalse(viewModel.isFormValid, "Un titolo di soli spazi non è valido")

        viewModel.title = "Colosseum"
        viewModel.body = "Long queue, worth it."
        viewModel.mood = .excited
        viewModel.latitude = 41.8902
        viewModel.longitude = 12.4922
        XCTAssertTrue(viewModel.isFormValid)

        viewModel.saveEntry(to: trip, context: context)
        try context.save()

        XCTAssertEqual(trip.entries.count, 1)
        let saved = try XCTUnwrap(trip.entries.first)
        XCTAssertEqual(saved.title, "Colosseum")
        XCTAssertEqual(saved.mood, .excited)
        XCTAssertEqual(saved.latitude, 41.8902, accuracy: 0.0001)
        XCTAssertIdentical(saved.trip, trip)

        // Il riassunto in cache parlava di un viaggio senza questa entry.
        XCTAssertNil(trip.aiSummary)
        XCTAssertNil(trip.aiHighlightsCSV)

        // Il form torna ai valori di default per la entry successiva.
        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.body, "")
        XCTAssertEqual(viewModel.mood, .calm)
        XCTAssertEqual(viewModel.imageName, "trip_beach")
        XCTAssertFalse(viewModel.isFormValid)
    }

    func testUpdateEntryInvalidatesSmartTagsAndTripSummary() throws {
        let trip = TestSupport.makeTrip()
        trip.aiSummary = "Cached"
        context.insert(trip)

        let entry = JournalEntry(
            title: "Vatican",
            body: "Museums",
            mood: .calm,
            latitude: 41.9,
            longitude: 12.45,
            smartTagsCSV: "art, museum"
        )
        trip.entries.append(entry)
        context.insert(entry)
        try context.save()

        viewModel.load(from: entry)
        XCTAssertEqual(viewModel.title, "Vatican")
        XCTAssertEqual(viewModel.mood, .calm)

        viewModel.title = "Vatican Museums"
        viewModel.mood = .happy
        viewModel.updateEntry(entry, context: context)
        try context.save()

        XCTAssertEqual(entry.title, "Vatican Museums")
        XCTAssertEqual(entry.mood, .happy)
        // I tag erano stati generati sul testo precedente: vanno rigenerati.
        XCTAssertNil(entry.smartTagsCSV)
        XCTAssertNil(trip.aiSummary)
    }
}
