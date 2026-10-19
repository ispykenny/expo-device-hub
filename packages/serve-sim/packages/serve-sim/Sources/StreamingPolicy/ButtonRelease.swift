/// Releases a pressed hardware button.
///
/// A failed release leaves the button held in the guest, for example a held
/// Lock button opens the power-off screen. Retry the release once; report the
/// first error only when the retry fails too.
public enum ButtonRelease {
    public static func release(
        retryDelay: Duration = .milliseconds(50),
        _ emit: () throws -> Void
    ) async throws {
        do {
            try emit()
        } catch let first {
            try? await Task.sleep(for: retryDelay)
            do { try emit() } catch { throw first }
        }
    }
}
