//
//  WeatherModel.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/3/23.
//

import Foundation
import UIKit

//struct WeatherModel: Decodable, Identifiable {
//    var id: Int?
//    var city: String?
//    var mainWeather: String?
//    var description: String?
//    var icon: UIImage?
//    var temperature: Float?
//    var feelsLike: Float?
//    var humidity: Int?
//
//    private enum ModelKeys: String, CodingKey {
//        case weather
//        case main
//        case city = "name"
//    }
//    private enum WeatherKeys: String, CodingKey {
//        case description
//        case mainWeather = "main"
//    }
//
//    private enum MainKeys: String, CodingKey {
//        case temperature = "temp"
//        case feelsLike = "feels_like"
//        case humidity
//    }
//
//    init(from decoder: Decoder) throws {
//        if let modelContainer = try? decoder.container(keyedBy: ModelKeys.self) {
//            self.city = try modelContainer.decode(String.self, forKey: .city)
//
//            if let weatherContainer = try? modelContainer.nestedContainer(keyedBy: WeatherKeys.self, forKey: .weather) {
//                self.mainWeather = try weatherContainer.decode(String.self, forKey: .mainWeather)
//                self.description = try weatherContainer.decode(String.self, forKey: .description)
//            }
//
//            if let mainContainer = try? modelContainer.nestedContainer(keyedBy: MainKeys.self, forKey: .main) {
//                self.temperature = try mainContainer.decode(Float.self, forKey: .temperature)
//                self.feelsLike = try mainContainer.decode(Float.self, forKey: .feelsLike)
//                self.humidity = try mainContainer.decode(Int.self, forKey: .humidity)
//            }
//        }
//    }
//}
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
