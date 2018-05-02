//
//  JSONRPCNotification.swift
//  JSONRPC
//
//  Created by Kojirou on 2018/5/2.
//

import Foundation

struct JSONRPCNotification<Parameters: Codable>: Codable {
    
    public let jsonrpc: String = "2.0"

    public var method: String

    public var params: Parameters
    
}
