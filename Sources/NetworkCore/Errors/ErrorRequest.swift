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
}
