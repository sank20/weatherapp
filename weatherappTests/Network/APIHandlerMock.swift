//
//  APIHandlerMock.swift
//  weatherappTests
//
//  Created by Sanket Pimple on 3/8/23.
//

import Foundation
@testable import weatherapp

final class APIHandlerMock: APIHandling {
    
    var isSuccess: Bool = false
    var isCorrectResponse = false
    
    init (isSuccess: Bool, isCorrectResponse: Bool) {
        self.isSuccess = isSuccess
        self.isCorrectResponse = isCorrectResponse
    }
    func fetchData(url: URL, completion: @escaping (Result<Data, weatherapp.APIError>) -> Void) {
        if isSuccess {
            var jsonMock: String
            if isCorrectResponse {
                jsonMock = "correct_response"
            }
            else {
                jsonMock = "wrong_response"
            }
            guard let pathString = Bundle(for: type(of: self)).path(forResource: jsonMock, ofType: "json"),
                  let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8),
                  let jsonData = jsonString.data(using: .utf8) else {
                return completion(.failure(.DecodingError))
            }
            completion(.success(jsonData))
        } else {
            completion(.failure(.UnexpectedError))
        }
    }
}

