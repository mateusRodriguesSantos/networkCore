//
//  ConnectionProtocol.swift
//  
//
//  Created by Mateus Rodrigues on 23/03/22.
//

import Foundation
import Network

public protocol ConnectionProtocol {
    var headers: [String: String]? { get set }
    var baseUrl: URL { get set }
    var port: String? { get set }
    var router: String { get set }
    var method: String? { get set }
    var components: [String: String]? { get set }
    var parameters: [String: Any]? { get set }
}
