//
//  JSONRPCResponse.swift
//  JSONRPC
//
//  Created by 王宇 on 2016/11/3.
//
//

import Foundation
import JSON

public struct JSONRPCResponse {
	public let id: String
	public let result: Any?
	public let error: JSONRPCResponseError?
}

extension JSONRPCResponse: JSONDeserializable {
	public init(jsonRepresentation json: JSONDictionary) throws {
		id = try decode(json, key: "id")
		result = try? decode(json, key: "result")
		error = try? decode(json, key: "error")
		
	}
}

public struct JSONRPCResponseError: JSONDeserializable {
	public var code: Int
	public var message: String
	public var data: Any?
	
	public init(jsonRepresentation json: JSONDictionary) throws {
		code = try decode(json, key: "code")
		message = try decode(json, key: "message")
		data = try? decode(json, key: "data")
	}
}
