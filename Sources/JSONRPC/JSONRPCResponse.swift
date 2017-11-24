//
//  JSONRPCResponse.swift
//  JSONRPC
//
//  Created by 王宇 on 2016/11/3.
//
//

import Foundation

public struct JSONRPCResponse<Result: Decodable, ErrorData: Decodable>: Decodable {
	
    public let jsonrpc: String
	public let id: JRPCID
	public let result: Result?
	public let error: JSONRPCResponseError<ErrorData>?
	
    public struct JSONRPCResponseError<ErrorData: Decodable>: Decodable {
        
        public var code: Int
        public var message: String
        public var data: ErrorData?
        
    }
    
}
