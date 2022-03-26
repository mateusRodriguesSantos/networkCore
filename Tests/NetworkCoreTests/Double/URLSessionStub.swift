//
//  URLSessionStub.swift
//  
//
//  Created by Mateus Rodrigues on 26/03/22.
//

import UIKit

class URLSessionStub: URLSession {

    var shouldReturnError: Bool = false
    var dataResponse: Data? = Data()
    var urlResponse: HTTPURLResponse = HTTPURLResponse()
    var statusCode: Int = 200
    var error: Error = NSError(domain: String(), code: 404, userInfo: nil)

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        if !shouldReturnError {
            urlResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            completionHandler(dataResponse, urlResponse , nil)
            return URLSessionDataTaskFake()
        }
        completionHandler(nil, nil , error)
        return URLSessionDataTaskFake()
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        if !shouldReturnError {
            urlResponse = HTTPURLResponse(url: request.url ?? URL(fileURLWithPath: String()), statusCode: statusCode, httpVersion: nil, headerFields: request.allHTTPHeaderFields)!
            completionHandler(dataResponse, urlResponse , nil)
            return URLSessionDataTaskFake()
        }
        completionHandler(nil, nil , error)
        return URLSessionDataTaskFake()
    }
}

class URLSessionDataTaskFake: URLSessionDataTask {
    override func resume() { }
}
