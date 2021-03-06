import XCTest
@testable import EventService

final class EventServiceTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(EventService().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
