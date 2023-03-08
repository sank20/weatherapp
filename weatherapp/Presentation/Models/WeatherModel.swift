//
//  WeatherModel.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/3/23.
//

import Foundation
import UIKit

struct WeatherModel : Decodable {
    var city: String = ""
    var weatherInfo: [WeatherInfo] = []
    var mainData: MainData = MainData()
    var timeStamp: Double?
    
    private enum CodingKeys: String, CodingKey {
        case weatherInfo = "weather"
        case mainData = "main"
        case city = "name"
        case timeStamp = "dt"
    }
}

struct WeatherInfo: Decodable {
    var mainWeather: String = ""
    var description: String = ""
    var icon: String = ""
    private enum CodingKeys: String, CodingKey {
        case description
        case mainWeather = "main"
        case icon
    }
}

struct MainData: Decodable {
    var temperature: Float?
    var feelsLike: Float?
    var humidity: Int?
    var minTemp: Float?
    var maxTemp: Float?
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case humidity
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}
