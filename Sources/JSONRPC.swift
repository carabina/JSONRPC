public struct JSONRPC {

	public static func send(request: JSONRPCRequest, completion: (_ result: Any?, _ error: Error?) -> Void) {
		
	}
	
	public static func send(requests: [JSONRPCRequest], completion: (_ result: [Any?], _ error: [Error?]) -> Void) {
		print(requests.jsonString)
	}
}

public enum JSONRPCError: Error {
	case wrongFormat
}
