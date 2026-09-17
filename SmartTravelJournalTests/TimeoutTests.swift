import XCTest
@testable import SmartTravelJournal

final class TimeoutTests: XCTestCase {
    /// Operazione veloce: torna il valore. Operazione lenta: `TimeoutError`
    /// senza aspettare che finisca (è la guardia contro Foundation Models che
    /// non risponde sul simulatore).
    func testWithTimeoutReturnsFastValueAndFailsFastOnSlowOperation() async throws {
        let value = try await withTimeout(seconds: 1) { 42 }
        XCTAssertEqual(value, 42)

        let start = ContinuousClock.now
        do {
            _ = try await withTimeout(seconds: 0.2) {
                try await Task.sleep(for: .seconds(10))
                return "never"
            }
            XCTFail("Expected TimeoutError")
        } catch is TimeoutError {
            // atteso
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        let elapsed = ContinuousClock.now - start
        XCTAssertLessThan(elapsed, .seconds(3), "Il timeout non deve aspettare l'operazione lenta")
    }
}
