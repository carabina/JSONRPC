import XCTest
@testable import JSONRPC

class JSONRPCTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(JSONRPC().text, "Hello, World!")
		print(JSONRPC().text)
    }


    static var allTests : [(String, (JSONRPCTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
