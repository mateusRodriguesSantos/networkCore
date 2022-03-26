//
//  ErrorRequest.swift
//  
//
//  Created by Mateus Rodrigues on 23/03/22.
//

import Foundation

public enum ErrorsRequests: Error {
    case lostConnection
    case statusError(error: String)
    case error(error: String)
    case dataNotFound
    case errorDecode
    
    var comparable: String {
        switch self {
        case .dataNotFound:
            return "error1"
        case .errorDecode:
            return "error2"
        case .error:
            return "error3"
        case .statusError:
            return "error4"
        case .lostConnection:
            return "error5"
        }
    }
}
