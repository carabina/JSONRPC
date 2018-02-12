//
//  JSONRPC.swift
//  JSONRPC
//
//  Created by 王宇 on 2016/10/11.
//
//

import Foundation

public class JSONRPC {
    
	public var rpcMethod: JSONRPCMethod = .httpURLSession
	
    public var url: URL
	
	public init(url: URL) {
		self.url = url
	}

    public func send<Result: Decodable, ErrorData: Decodable>(request: JSONRPCRequest, completion: @escaping (_ response: JSONRPCResponse<Result, ErrorData>?, _ error: Error?) -> Void) throws {
		var urlreq = URLRequest(url: url)
		urlreq.httpMethod = "POST"
		urlreq.httpBody = try request.httpBody()
        #if DEBUG
        print(String(data: try request.httpBody(), using: .utf8)!)
        #endif
		URLSession.shared.dataTask(with: urlreq, completionHandler: {(data, response, error) -> Void in
			guard error == nil else {
                completion(nil, error)
				return
			}
			guard let data = data else {
				completion(nil, JSONRPCError.nullResponse)
				return
			}
            #if DEBUG
            print(String(data: data, using: .utf8)!)
            #endif
			do {
				let rpcResp = try JSONDecoder().decode(JSONRPCResponse<Result, ErrorData>.self, from: data)
				completion(rpcResp, nil)
			} catch {
				completion(nil, error)
			}
		}).resume()
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

public enum JSONRPCMethod {
    @available(*,unavailable)
	case webSocket
	case httpURLSession
    @available(*,unavailable)
	case httpCurl
}
