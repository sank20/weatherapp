//
//  WeatherAPIService.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/7/23.
//

import Foundation
import CoreLocation

enum Unit: String {
    case imperial
    case metric
    case standard
}

protocol WeatherRequest {
    func getWeather(coordinate: CLLocationCoordinate2D, unit: Unit, completion: @escaping(Result<WeatherModel, APIError>) -> Void)
}

// Future improvements: in case of large number of request, we can abstract out all request protocols so that the service
// class will have to conform to one protocol typealias. Eg. in case there is a new API in the future in addition to WeatherRequest
final class WeatherAPIRequest: WeatherRequest {
    
    private let apiKey = "d0d6ea9cd1097d3795ca6c8fe0c327cb"
    
    func getWeather(coordinate: CLLocationCoordinate2D, unit: Unit, completion: @escaping (Result<WeatherModel, APIError>) -> Void) {
        var url: URL {
            var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
            components.queryItems = [
                URLQueryItem(name: "lat", value: coordinate.latitude.description),
                 URLQueryItem(name: "lon", value: coordinate.longitude.description),
                URLQueryItem(name: "units", value: unit.rawValue),
                URLQueryItem(name: "appid", value: apiKey) // TODO: store the APIKey in a secure place, like keychain
            ]
            return components.url!
        }
        NetworkManager().fetchRequest(type: WeatherModel.self, url: url, completion: completion)
    }
    
}
