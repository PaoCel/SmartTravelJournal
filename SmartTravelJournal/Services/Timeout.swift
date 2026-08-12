import Foundation

/// Esegue `operation` con un limite di tempo. Se scade, lancia `TimeoutError`
/// e l'operazione viene cancellata.
///
/// Serve per le chiamate a Foundation Models: sul simulatore il modello risulta
/// disponibile ma la generazione può non tornare mai, e senza un limite la UI
/// resterebbe in caricamento all'infinito.
func withTimeout<T: Sendable>(
    seconds: TimeInterval,
    operation: @escaping @Sendable () async throws -> T
) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask { try await operation() }
        group.addTask {
            try await Task.sleep(for: .seconds(seconds))
            throw TimeoutError()
        }

        guard let result = try await group.next() else {
            throw TimeoutError()
        }
        group.cancelAll()
        return result
    }
}

struct TimeoutError: Error, LocalizedError {
    var errorDescription: String? {
        "The operation timed out."
    }
}
