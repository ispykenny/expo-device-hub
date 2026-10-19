import XCTest
@testable import StreamingPolicy

private struct ReleaseFailed: Error, Equatable { let attempt: Int }

final class ButtonReleaseTests: XCTestCase {
    func testReleasesOnceWhenTheFirstReleaseWorks() async throws {
        var attempts = 0
        try await ButtonRelease.release(retryDelay: .zero) { attempts += 1 }
        XCTAssertEqual(attempts, 1)
    }

    func testRetriesAFailedReleaseOnce() async throws {
        var attempts = 0
        try await ButtonRelease.release(retryDelay: .zero) {
            attempts += 1
            if attempts == 1 { throw ReleaseFailed(attempt: attempts) }
        }
        XCTAssertEqual(attempts, 2)
    }

    func testReportsTheFirstErrorWhenTheRetryFailsToo() async {
        var attempts = 0
        do {
            try await ButtonRelease.release(retryDelay: .zero) {
                attempts += 1
                throw ReleaseFailed(attempt: attempts)
            }
            XCTFail("expected the release to fail")
        } catch {
            XCTAssertEqual(error as? ReleaseFailed, ReleaseFailed(attempt: 1))
        }
        XCTAssertEqual(attempts, 2)
    }
}
