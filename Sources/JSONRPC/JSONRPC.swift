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

    public func send<Parameters, Result, ErrorData>(request: JSONRPCRequest<Parameters>, completion: @escaping (_ response: JSONRPCResponse<Result, ErrorData>?, _ error: Error?) -> Void) throws {
		var urlreq = URLRequest(url: url)
		urlreq.httpMethod = "POST"
		urlreq.httpBody = try JSONEncoder().encode(request)
		URLSession.shared.dataTask(with: urlreq, completionHandler: {(data, response, error) -> Void in
			guard error == nil else {
				completion(nil, error!)
				return
			}
			guard let data = data else {
				completion(nil, JSONRPCError.responseBodyError)
				return
			}
			do {
				let rpcResp = try JSONDecoder().decode(JSONRPCResponse<Result, ErrorData>.self, from: data)
				completion(rpcResp, nil)
			} catch {
				completion(nil, error)
			}
		}).resume()
	}
	
    // MARK: - later
    /*
	public func send(requests: [JSONRPCRequest], completion: @escaping (_ responses: [JSONRPCResponse?]?, _ error: Error?) -> Void) throws {
		var urlreq = URLRequest(url: url)
		urlreq.httpMethod = "POST"
		urlreq.httpBody = try JSONSerialization.data(withJSONObject: requests.map({ $0.jsonRepresentation }), options: .prettyPrinted)
		URLSession.shared.dataTask(with: urlreq, completionHandler: {(data, response, error) -> Void in
			guard error == nil else {
				completion(nil, error!)
				return
			}
			guard let data = data,
				let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
				let json = jsonObject as? [JSONDictionary] else {
					completion(nil, JSONRPCError.responseBodyError)
					return
			}
//			do {
				completion(json.map({ try? JSONRPCResponse(jsonRepresentation: $0) }), nil)
//			} catch {
//				completion(nil, error)
//			}
		}).resume()
	}
 */

}

public enum JSONRPCError: Error {
	case wrongFormat
	case wrongVersion
	case responseBodyError
}

public enum JSONRPCMethod {
	case webSocket
	case httpURLSession
	case httpCurl
}
