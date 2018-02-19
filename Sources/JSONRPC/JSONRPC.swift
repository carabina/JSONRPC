//
//  JSONRPC.swift
//  JSONRPC
//
//  Created by 王宇 on 2016/10/11.
//
//

import Foundation
import PerfectCURL

public class JSONRPC {
    
    public var networkMethod: JSONRPCNetworkMethod
	
    public let url: URL
	
	public init(url: URL) {
		self.url = url
        #if os(Linux)
        networkMethod = .httpURLSession
        #elseif os(macOS)
        networkMethod = .httpCURL
        #endif
	}

    public func send<Result: Decodable, ErrorData: Decodable>(request: JSONRPCRequest, completion: @escaping (_ response: JSONRPCResponse<Result, ErrorData>?, _ error: Error?) -> Void) throws {
        switch networkMethod {
        case .httpCURL:
            let request = CURLRequest.init(url.absoluteString, options: [.postData(Array(try request.httpBody()))])
            let response = try request.perform()
            let rpcR = try response.bodyJSON(JSONRPCResponse<Result, ErrorData>.self)
            completion(rpcR, nil)
        case .httpURLSession:
            var urlreq = URLRequest(url: url)
            urlreq.httpMethod = "POST"
            urlreq.httpBody = try request.httpBody()
            URLSession.shared.dataTask(with: urlreq, completionHandler: {(data, response, error) -> Void in
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, JSONRPCError.nullResponse)
                    return
                }
                do {
                    let rpcResp = try JSONDecoder().decode(JSONRPCResponse<Result, ErrorData>.self, from: data)
                    completion(rpcResp, nil)
                } catch {
                    completion(nil, error)
                }
            }).resume()
        case .webSocket:
            fatalError("Websocket not supported!")
        }
		
	}
    
    public func send(rawRequest: [String: Any], completion: @escaping ([String: Any]?) -> Void) throws {
        var urlreq = URLRequest(url: url)
        urlreq.httpMethod = "POST"
        urlreq.httpBody = try JSONSerialization.data(withJSONObject: rawRequest, options: .prettyPrinted)
        URLSession.shared.dataTask(with: urlreq, completionHandler: {(data, response, error) -> Void in
            if error == nil, let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                completion(json)
            } else {
                completion(nil)
            }
        }).resume()
    }
    
    public func send(requests: [JSONRPCRequest], completion: @escaping (_ responses: [[String: Any]]?, _ error: Error?) -> Void) throws {
		var urlreq = URLRequest(url: url)
		urlreq.httpMethod = "POST"
        urlreq.httpBody = try JSONSerialization.data(withJSONObject: requests.map{try $0.httpBody()}, options: [])
		URLSession.shared.dataTask(with: urlreq, completionHandler: {(data, response, error) -> Void in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let resultArray = json as? [[String: Any]] else {
                completion(nil, JSONRPCError.nullResponse)
                return
            }
            completion(resultArray, nil)
		}).resume()
	}
 
}

public enum JSONRPCError: Error {
	case nullResponse
}

public enum JSONRPCNetworkMethod {
	case webSocket
	case httpURLSession
	case httpCURL
}
