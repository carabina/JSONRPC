//
//  JSONRPC.swift
//  JSONRPC
//
//  Created by 王宇 on 2016/10/11.
//
//

import Foundation
import PerfectCURL
import Starscream

public class JSONRPC {
    
    public let url: URL
    
    private let networkMethod: NetworkMethod
	
    private var completions: [JRPCID: ((Data) -> ())]
    
    private let decoder: JSONDecoder
    
    private let queue: OperationQueue
    
    public var notificationHandler: ((Data) -> ())?
    
    private enum NetworkMethod {
        case webSocket(WebSocket)
        case httpURLSession(URLSession)
        case httpCURL
    }
    
    public init(url: URL, networkMethod: JSONRPCNetworkMethod = .httpURLSession) {
        
		self.url = url
        self.completions = [:]
        self.decoder = JSONDecoder()
        self.queue = OperationQueue.init()
        self.queue.maxConcurrentOperationCount = 1
        self.notificationHandler = nil
        switch networkMethod {
        case .httpURLSession:
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            let session = URLSession.init(configuration: config)
            self.networkMethod = .httpURLSession(session)
        case .webSocket:
            let ws = WebSocket(url: url)
            self.networkMethod = .webSocket(ws)
            ws.delegate = self
            ws.connect()
        default:
            fatalError()
        }
	}
    
    deinit {
        switch networkMethod {
        case .webSocket(let ws):
            ws.disconnect()
        default:
            break
        }
    }

    public func send<Result: Decodable, ErrorData: Decodable>(request: JSONRPCRequest, completion: @escaping (_ response: JSONRPCResponse<Result, ErrorData>?, _ error: Error?) -> Void) throws {
        switch networkMethod {
        case .httpCURL:
            let request = CURLRequest.init(url.absoluteString, options: [.postData(Array(try request.httpBody()))])
            let response = try request.perform()
            let rpcR = try response.bodyJSON(JSONRPCResponse<Result, ErrorData>.self)
            completion(rpcR, nil)
        case .httpURLSession(let session):
            var urlreq = URLRequest(url: url)
            urlreq.httpMethod = "POST"
            urlreq.httpBody = try request.httpBody()
            session.dataTask(with: urlreq, completionHandler: {(data, response, error) -> Void in
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, JSONRPCError.nullResponse)
                    return
                }
                do {
                    let rpcResp = try self.decoder.decode(JSONRPCResponse<Result, ErrorData>.self, from: data)
                    completion(rpcResp, nil)
                } catch {
                    completion(nil, error)
                }
            }).resume()
        case .webSocket(let ws):
            ws.write(data: try request.httpBody()) {
                self.queue.addOperation {
                    self.completions[request.id] = { data in
                        do {
                            let rpcResp = try self.decoder.decode(JSONRPCResponse<Result, ErrorData>.self, from: data)
                            completion(rpcResp, nil)
                        } catch {
                            completion(nil, error)
                        }
                    }
                }
            }
        }
		
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

extension JSONRPC: WebSocketDelegate {
    
    public func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(error?.localizedDescription ?? "No error info!")")
        queue.addOperation {
            self.completions = [:]
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("websocketDidReceiveMessage")
        let data = text.data(using: .utf8)!
        do {
            let resID = try decoder.decode(JSONRPCResponseID.self, from: data)
            completions[resID.id]?(data)
            queue.addOperation {
                self.completions[resID.id] = nil
            }
        } catch {
            // no id, it's a notification
            notificationHandler?(data)
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
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
