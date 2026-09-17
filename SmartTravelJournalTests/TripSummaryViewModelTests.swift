import XCTest
import SwiftData
@testable import SmartTravelJournal

@MainActor
final class TripSummaryViewModelTests: XCTestCase {
    private var container: ModelContainer!
    private var context: ModelContext!

    override func setUp() async throws {
        container = try TestSupport.makeContainer()
        context = ModelContext(container)
    }

    /// Con un riassunto già salvato sul viaggio il ViewModel non deve chiamare
    /// il modello: legge la cache e riparte dai CSV, scartando le voci vuote.
    func testGenerateUsesCachedSummaryAndParsesHighlightsCSV() async throws {
        let trip = TestSupport.makeTrip()
        trip.aiSummary = "Three days of pasta and ruins."
        trip.aiHighlightsCSV = " Colosseum ,Trastevere,, Gelato "
        context.insert(trip)

        let viewModel = TripSummaryViewModel()
        await viewModel.generate(for: trip, context: context)

        let summary = try XCTUnwrap(viewModel.summary)
        XCTAssertEqual(summary.summary, "Three days of pasta and ruins.")
        XCTAssertEqual(summary.highlights, ["Colosseum", "Trastevere", "Gelato"])
        XCTAssertTrue(viewModel.wasGeneratedByAI)
        XCTAssertFalse(viewModel.isGenerating)
        XCTAssertNil(viewModel.errorMessage)
    }

    /// `retry` deve buttare la cache sul modello e ripartire: con un viaggio senza
    /// entry non si arriva mai alla generazione, quindi il test è deterministico
    /// anche dove Apple Intelligence non è disponibile.
    func testRetryClearsCachedSummaryOnTrip() async throws {
        let trip = TestSupport.makeTrip()
        trip.aiSummary = "Stale"
        trip.aiHighlightsCSV = "stale"
        context.insert(trip)

        let viewModel = TripSummaryViewModel()
        await viewModel.retry(for: trip, context: context)

        XCTAssertNil(trip.aiSummary)
        XCTAssertNil(trip.aiHighlightsCSV)
        XCTAssertFalse(viewModel.wasGeneratedByAI)
        let summary = try XCTUnwrap(viewModel.summary)
        XCTAssertNotEqual(summary.summary, "Stale")
        XCTAssertTrue(summary.highlights.isEmpty)
    }
}
