//
//  Service.swift
//  ApplyDigitalTest
//
//  Created by Jose Caraballo on 8/10/22.
//

import Foundation
import Combine

protocol Service {
    func requestNew<T: Decodable>(from endpoint: NewsAPI, type: T.Type) -> AnyPublisher<T, APIError>
}

struct ServiceImplementation: Service {
    
    //MARK: - Generic request
    
    func requestNew<T: Decodable>(from endpoint: NewsAPI, type: T.Type) -> AnyPublisher<T, APIError> {
        
        guard let urlRequest = endpoint.asURLRequest() else {
            return Fail(outputType: T.self, failure: APIError.custom(error: "Error within request" as! Error)).eraseToAnyPublisher()
        }
        
        return URLSession
            .shared
            .dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError{ error in return APIError.custom(error: error) }
            .flatMap { data, resp -> AnyPublisher<T, APIError> in
                
                guard let response = resp as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode <= 300 else {
                    return Fail(error: APIError.invalidStatus).eraseToAnyPublisher()
                }
                
                let jsonDecoder = JSONDecoder()
                //jsonDecoder.dateDecodingStrategy = .iso8601
             
                return Just(data)
                    .decode(type: type, decoder: jsonDecoder)
                    .mapError{ _ in APIError.decodingError }
                    .eraseToAnyPublisher()
                
            }.eraseToAnyPublisher()
    }
    
    
}
