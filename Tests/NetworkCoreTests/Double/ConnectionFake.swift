//
//  ConnectionFake.swift
//  
//
//  Created by Mateus Rodrigues on 26/03/22.
//

import Foundation
@testable import NetworkCore

struct ConnectionFake: ConnectionProtocol {
    var headers: [String : String]?
    
    var baseUrl: URL
    
    var port: String?
    
    var router: String
    
    var method: String?
    
    var components: [String : String]?
    
    var parameters: [String : Any]?
    
    init() {
        headers =  ["application/json" : "content-type"]
        port = nil
        method = nil
        components = ["id" : "345"]
        parameters = ["name" : "john"]
        baseUrl = URL(string: "https://tests.testables/") ?? URL(fileURLWithPath: "")
        router = "list"
    }
}
