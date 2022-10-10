//
//  APIError.swift
//  ApplyDigitalTest
//
//  Created by Jose Caraballo on 8/10/22.
//

import Foundation

enum APIError: Error {
    case decodingError
    case errorCode(Int)
    case unknow
    case custom(error: Error)
    case invalidStatus
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .decodingError:
            return "Failed to decode the object from the service"
        case .errorCode(let code):
            return "\(code) - something went wrong"
        case .unknow:
            return "The error is unknown"
        case .custom(let error) :
            return "\(error.localizedDescription)"
        case .invalidStatus:
            return "Resquest falls within an invalid range"
        }
    }
}
