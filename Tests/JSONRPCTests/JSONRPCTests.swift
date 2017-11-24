import XCTest
@testable import JSONRPC

class JSONRPCTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let response = "{\"jsonrpc\": \"2.0\", \"result\": 19, \"id\": 4}".data(using: .utf8)!
        print(try! JSONDecoder().decode(JSONRPCResponse<Int, String>.self, from: response))
    }

    func testFail() {
        let response = """
        {"jsonrpc": "2.0", "error": {"code": -32601, "message": "Method not found"}, "id": "1"}
        """.data(using: .utf8)!
        print(try! JSONDecoder().decode(JSONRPCResponse<Int, String>.self, from: response))
    }
    
    func testNullID() {
        let response = """
        {"jsonrpc": "2.0", "error": {"code": -32600, "message": "Invalid Request"}, "id": null}
        """.data(using: .utf8)!
        print(try! JSONDecoder().decode(JSONRPCResponse<Int, String>.self, from: response))
    }
    

    static var allTests : [(String, (JSONRPCTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
