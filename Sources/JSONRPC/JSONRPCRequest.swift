//
//  JSONRPCRequest.swift
//  JSONRPC
//
//  Created by 王宇 on 2016/10/11.
//
//

import Foundation

public enum JRPCID: Codable, Equatable {
    
    public static func ==(lhs: JRPCID, rhs: JRPCID) -> Bool {
        switch (lhs, rhs) {
        case let (.number(l), .number(r)):
            return l == r
        case let (.string(l), .string(r)):
            return l == r
        case (.null, .null):
            return true
        default:
            return false
        }
    }
    
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

public struct EmptyData : Codable {}
public let NullParams = EmptyData()

public protocol JSONRPCRequest {
    func httpBody() throws -> Data
}

public struct JSONRPCEncodableRequest<Parameters: Encodable>: JSONRPCRequest, Encodable {

    public func httpBody() throws -> Data {
        return try JSONEncoder().encode(self)
    }
	
	/// A String specifying the version of the JSON-RPC protocol. MUST be exactly "2.0".
	public let jsonrpc: String = "2.0"
	
	/// A String containing the name of the method to be invoked. Method names that begin with the word rpc followed by a period character (U+002E or ASCII 46) are reserved for rpc-internal methods and extensions and MUST NOT be used for anything else.
	public var method: String
	
	/// An identifier established by the Client that MUST contain a String, Number, or NULL value if included. If it is not included it is assumed to be a notification. The value SHOULD normally not be Null and Numbers SHOULD NOT contain fractional parts.
	public var id: JRPCID
	
	/// A Structured value that holds the parameter values to be used during the invocation of the method. This member MAY be omitted.
	public var params: Parameters
	
    enum CodingKeys: String, CodingKey {
        case jsonrpc, method, id, params
    }
    
    public init(method: String, params: Parameters, id: JRPCID = .string("jsonrpc")) {
        self.method = method
        self.params = params
        self.id = id
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jsonrpc, forKey: .jsonrpc)
        try container.encode(method, forKey: .method)
        switch id {
        case .null:
            // It's a notification.
            break
        default:
            try container.encode(id, forKey: .id)
        }
        if params is EmptyData {
            
        } else {
            try container.encode(params, forKey: .params)
        }
    }
    
}

public struct JSONRPCLegacyRequest: JSONRPCRequest {

    public func httpBody() throws -> Data {
        var json: [String: Any] = [
            "jsonrpc": jsonrpc,
            "method": method
        ]
        if params != nil {
            json["params"] = params!
        }
        switch id {
        case .null:
            break
        case .number(let number):
            json["id"] = number
        case .string(let str):
            json["id"] = str
        }
        return try JSONSerialization.data(withJSONObject: json, options: [])
    }

    /// A String specifying the version of the JSON-RPC protocol. MUST be exactly "2.0".
    public let jsonrpc: String = "2.0"

    /// A String containing the name of the method to be invoked. Method names that begin with the word rpc followed by a period character (U+002E or ASCII 46) are reserved for rpc-internal methods and extensions and MUST NOT be used for anything else.
    public var method: String

    /// An identifier established by the Client that MUST contain a String, Number, or NULL value if included. If it is not included it is assumed to be a notification. The value SHOULD normally not be Null and Numbers SHOULD NOT contain fractional parts.
    public var id: JRPCID

    /// A Structured value that holds the parameter values to be used during the invocation of the method. This member MAY be omitted.
    public var params: Any?

    public init(method: String, params: Any? = nil, id: JRPCID = .string("jsonrpc")) {
        self.method = method
        self.params = params
        self.id = id
    }

}


