//
//  JSONRPCRequest.swift
//  JSONRPC
//
//  Created by 王宇 on 2016/10/11.
//
//

import Foundation
import SFJSON
import SwiftyJSON

public struct JSONRPCRequest {
	/// A String specifying the version of the JSON-RPC protocol. MUST be exactly "2.0".
	public let jsonrpc = "2.0"
	
	/// A String containing the name of the method to be invoked. Method names that begin with the word rpc followed by a period character (U+002E or ASCII 46) are reserved for rpc-internal methods and extensions and MUST NOT be used for anything else.
	public var method: String
	
	/// An identifier established by the Client that MUST contain a String, Number, or NULL value if included. If it is not included it is assumed to be a notification. The value SHOULD normally not be Null and Numbers SHOULD NOT contain fractional parts.
	public var id: String
	
	/// A Structured value that holds the parameter values to be used during the invocation of the method. This member MAY be omitted.
	public var params: Any?
	
	public init(method: String, params: Any? = nil, id: String = "qwer") {
		self.method = method
		self.params = params
		self.id = id
	}
}

extension JSONRPCRequest: SFModel {
	
	public init(json: JSON) throws {
		guard let jsonrpc = json["jsonrpc"].string, jsonrpc == "2.0", let method = json["method"].string, let id = json["id"].string else {
			throw JSONRPCError.wrongFormat
		}
		self.method = method
		self.id = id
		self.params = json["params"].object
	}
	
}
