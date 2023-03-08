//
//  WeatherViewModel.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/3/23.
//

import Foundation
import CoreLocation

final class WeatherViewModel {
    
    let service: WeatherAPIRequest
    
    private var weatherData: [WeatherModel] = []
    private var currentLocationWeatherData: [WeatherModel] = []

    let userDefaults = UserDefaults.standard

    init(service: WeatherAPIRequest = WeatherAPIRequest()) {
        self.service = service
    }
    
    func fetchLastLocation(completion: @escaping(Result<WeatherModel, APIError>) -> Void) {
        if let lastLat = userDefaults.string(forKey: "last_lat"),
           let lastLon = userDefaults.string(forKey: "last_lon") {
            let lastCoordinate = CLLocationCoordinate2D(latitude: Double(lastLat) ?? 0.0, longitude: Double(lastLon) ?? 0.0)
            fetchWeather(coordinate: lastCoordinate) { result in
                switch result {
                case .success(let weather):
                    self.weatherData = [weather]
                case .failure(let error):
                    print(error)
                }
                completion(result)
            }
        }
    }
    
    
    func fetchWeather(coordinate: CLLocationCoordinate2D, unit: Unit = .imperial, completion: @escaping(Result<WeatherModel, APIError>) -> Void) {
        service.getWeather(coordinate: coordinate, unit: unit) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let weather):
                    self?.weatherData.append(weather)
                case .failure(let error):
                    print(error)
                }
                completion(result)
            }
        }
    }
    
    func fetchCurrentLocWeather(coordinate: CLLocationCoordinate2D, unit: Unit = .imperial, completion: @escaping(Result<WeatherModel, APIError>) -> Void) {
        service.getWeather(coordinate: coordinate, unit: unit) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let weather):
                    self?.currentLocationWeatherData = [weather]
                case .failure(let error):
                    print(error)
                }
                completion(result)
            }
        }
    }
    
    
    
    
    func setLastLocation(coordinate: CLLocationCoordinate2D) {
        userDefaults.set(coordinate.latitude.description, forKey: "last_lat")
        userDefaults.set(coordinate.longitude.description, forKey: "last_lon")
    }
    
    func setCurrentLocation(weatherData: WeatherModel) {
        currentLocationWeatherData = [weatherData]
    }
    
    func getWeatherData() -> [WeatherModel] {
        return weatherData
    }
    
    func getCurrentLocationWeatherData() -> WeatherModel? {
        return currentLocationWeatherData.first
    }
}
