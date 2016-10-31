//
//  JSONRPC.swift
//  JSONRPC
//
//  Created by 王宇 on 2016/10/11.
//
//

import Foundation


public struct JSONRPC {

	public static func send(request: JSONRPCRequest, completion: @escaping (_ result: Any?, _ error: Error?) -> Void) {
		guard let body = try? JSONSerialization.data(withJSONObject: request.jsonRepresentation, options: .prettyPrinted) else {
			return
		}
//		print(String(data: body, encoding: .utf8)!)
	}
	
	public static func send(requests: [JSONRPCRequest], completion: @escaping (_ result: [Any?], _ error: [Error?]) -> Void) {
		guard let body = try? JSONSerialization.data(withJSONObject: requests.map({ $0.jsonRepresentation }), options: .prettyPrinted) else {
			return
		}
//		print(String(data: body, encoding: .utf8)!)
	}
}

public enum JSONRPCError: Error {
	case wrongFormat
	case wrongVersion
}
