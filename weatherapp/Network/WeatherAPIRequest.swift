//
//  WeatherAPIService.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/7/23.
//

import Foundation

enum Unit: String {
    case imperial
    case metric
    case standard
}

protocol WeatherRequest {
    func getWeather(city: String, unit: Unit, completion: @escaping(Result<WeatherModel, APIError>) -> Void)
}

// in case of large number of request, abstract out all request protocols so that the service
// class will have to conform to one protocol typealias
class WeatherAPIRequest: WeatherRequest {
    
    func getWeather(city: String, unit: Unit, completion: @escaping (Result<WeatherModel, APIError>) -> Void) {
        var url: URL {
            var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
            components.queryItems = [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "units", value: unit.rawValue),
                URLQueryItem(name: "appid", value: "d0d6ea9cd1097d3795ca6c8fe0c327cb") // TODO: store the APIKey in a secure place, like keychain
            ]
            return components.url!
        }
        NetworkManager().fetchRequest(type: WeatherModel.self, url: url, completion: completion)
    }
    
}
