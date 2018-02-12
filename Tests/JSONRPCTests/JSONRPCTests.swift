import XCTest
@testable import JSONRPC

class JSONRPCTests: XCTestCase {

    func testFailResponse() {
        let response = """
        {"jsonrpc": "2.0", "error": {"code": -32601, "message": "Method not found"}, "id": "1"}
        """.data(using: .utf8)!
        let rpcR = try! JSONDecoder().decode(JSONRPCResponse<Int, String>.self, from: response)
        XCTAssertEqual(rpcR.id, JRPCID.string("1"))
        XCTAssertEqual(rpcR.result, nil)
        XCTAssertEqual(rpcR.error?.code, -32601)
        XCTAssertEqual(rpcR.error?.message, "Method not found")
    }
    
    func testWrongDataTypeResponse() {
        let response = """
        {"jsonrpc": "2.0", "error": {"code": -32601, "message": "Method not found", "data":123}, "id": "1"}
        """.data(using: .utf8)!
        do {
            _ = try JSONDecoder().decode(JSONRPCResponse<Int, String>.self, from: response)
        } catch {
            print(error)
        }
    }
    
    func testNullID() {
        let response = """
        {"jsonrpc": "2.0", "error": {"code": -32600, "message": "Invalid Request"}, "id": null}
        """.data(using: .utf8)!
        let rpcR = try! JSONDecoder().decode(JSONRPCResponse<Int, String>.self, from: response)
        XCTAssertEqual(rpcR.id, JRPCID.null)
    }
    
    func testArrayParam() {
        let request = JSONRPCEncodableRequest(method: "subtract", params: [42, 23], id: .number(1))
        let data = try! request.httpBody()
        let encodedJSON = String.init(data: data, encoding: .utf8)!
        XCTAssertEqual("""
        {"jsonrpc":"2.0","method":"subtract","id":1,"params":[42,23]}
        """, encodedJSON)
    }
    
    func testNestedParam() {
        struct NestedParam: Encodable {
            var subtrahend: Int
            var minuend: Int
        }
        let request = JSONRPCEncodableRequest(method: "subtract", params: NestedParam.init(subtrahend: 23, minuend: 42), id: .number(1))
        let data = try! request.httpBody()
        let encodedJSON = String.init(data: data, encoding: .utf8)!
        XCTAssertEqual("""
        {"jsonrpc":"2.0","method":"subtract","id":1,"params":{"minuend":42,"subtrahend":23}}
        """, encodedJSON)
    }
    
    func testNotificationWithParam() {
        let request = JSONRPCEncodableRequest(method: "notify_sum", params: [1, 2, 4], id: .null)
        let data = try! request.httpBody()
        let encodedJSON = String.init(data: data, encoding: .utf8)!
        XCTAssertEqual("""
        {"jsonrpc":"2.0","method":"notify_sum","params":[1,2,4]}
        """, encodedJSON)
    }
    
    func testNotificationWithoutParam() {
        let request = JSONRPCEncodableRequest(method: "foobar", params: NullParams, id: .null)
        let data = try! request.httpBody()
        let encodedJSON = String.init(data: data, encoding: .utf8)!
        XCTAssertEqual("""
        {"jsonrpc":"2.0","method":"foobar"}
        """, encodedJSON)
    }
    
    static var allTests : [(String, (JSONRPCTests) -> () throws -> Void)] {
        return [
            
        ]
    }
}
