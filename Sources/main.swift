//
//  main.swift
//  JSONRPC
//
//  Created by 王宇 on 2016/11/4.
//
//

import Foundation

let rpc = JSONRPC(url: URL(string: "http://127.0.0.1:6800/jsonrpc")!)
try! rpc.send(request: JSONRPCRequest.init(method: "aria2.tellActive", params: [], id: "qwer"), completion: { (response, error) -> Void in
	print(response?.result)
})

pause()
