//
//  NetworkManager.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/7/23.
//

import Foundation

enum APIError: Error {
    case BadURL
    case NoData
    case DecodingError
    case UnexpectedError
}
/**
 Generic class to make API calls and get response
 */
final class NetworkManager {
    let apiHandler: APIHandling
    let responseHandler: ResponseHandling
    
    init(apiHandler: APIHandling = APIHandler(),
         responseHandler: ResponseHandling = ResponseHandler()) {
        self.apiHandler = apiHandler
        self.responseHandler = responseHandler
    }
    
    func fetchRequest<T: Decodable>(type: T.Type, url: URL, completion: @escaping(Result<T, APIError>) -> Void) {
       
        apiHandler.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                self.responseHandler.fetchModel(type: type, data: data) { decodedResult in
                    switch decodedResult {
                    case .success(let model):
                        completion(.success(model))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    
}

protocol APIHandling {
    func fetchData(url: URL, completion: @escaping(Result<Data, APIError>) -> Void)
}

final class APIHandler: APIHandling {
    func fetchData(url: URL, completion: @escaping(Result<Data, APIError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.NoData))
            }
            completion(.success(data))
           
        }.resume()
    }
    
}

protocol ResponseHandling {
    func fetchModel<T: Decodable>(type: T.Type, data: Data, completion: (Result<T, APIError>) -> Void)
}

final class ResponseHandler: ResponseHandling {
    func fetchModel<T: Decodable>(type: T.Type, data: Data, completion: (Result<T, APIError>) -> Void) {
        let weatherResponse = try? JSONDecoder().decode(type.self, from: data)
        if let weatherResponse = weatherResponse {
            return completion(.success(weatherResponse))
        } else {
            completion(.failure(.DecodingError))
        }
    }
    
}
