//
//  JSONRPCRequest.swift
//  JSONRPC
//
//  Created by 王宇 on 2016/10/11.
//
//

import Foundation

public enum JRPCID: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let numberValue = try? container.decode(Int.self) {
            self = .number(numberValue)
        } else {
            self = .null
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null:
            try container.encodeNil()
        case .number(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
    
    case string(String)
    case number(Int)
    case null
}

public struct JSONRPCRequest<Parameters: Encodable>: Encodable {
	
	/// A String specifying the version of the JSON-RPC protocol. MUST be exactly "2.0".
	public let jsonrpc: String = "2.0"
	
	/// A String containing the name of the method to be invoked. Method names that begin with the word rpc followed by a period character (U+002E or ASCII 46) are reserved for rpc-internal methods and extensions and MUST NOT be used for anything else.
	public var method: String
	
	/// An identifier established by the Client that MUST contain a String, Number, or NULL value if included. If it is not included it is assumed to be a notification. The value SHOULD normally not be Null and Numbers SHOULD NOT contain fractional parts.
	public var id: JRPCID
	
	/// A Structured value that holds the parameter values to be used during the invocation of the method. This member MAY be omitted.
	public var params: Parameters?
	
    public init(method: String, params: Parameters? = nil, id: JRPCID = .string("jsonrpc")) {
        self.method = method
        self.params = params
        self.id = id
    }

}


