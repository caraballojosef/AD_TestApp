//
//  Endpoint.swift
//  ApplyDigitalTest
//
//  Created by Jose Caraballo on 8/10/22.
//

import Foundation

protocol APIBuilder {
    //var urlRequest: URLRequest { get }
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: String { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
}

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

enum NewsAPI {
    case getPost
}

extension NewsAPI: APIBuilder {
    
    var method: HTTPMethod {
        switch self {
        case .getPost:
            return .get
        }
    }
    
    var contentType: String {
        switch self {
        case .getPost:
            return "application/json"
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getPost:
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getPost:
            return nil
        }
    }
    
    var baseUrl: String {
        switch self {
        case .getPost:
            return "https://hn.algolia.com/api/v1/search_by_date?query=mobile"
        }
    }
    
    var path: String {
        return "/"
    }
    
}

extension NewsAPI {
    
    private func requestBodyFrom(params: [String: Any]?) -> Data? {
        guard let params = params else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return httpBody
    }
    
    func asURLRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseUrl) else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"
        guard let finalURL = urlComponents.url else { return nil }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = requestBodyFrom(params: body)
        request.allHTTPHeaderFields = headers
        return request
    }
}
