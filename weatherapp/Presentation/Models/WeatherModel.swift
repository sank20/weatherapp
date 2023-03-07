//
//  WeatherModel.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/7/23.
//

import Foundation
import UIKit

struct WeatherModel: Decodable, Identifiable {
    var id: Int?
    var city: String?
    var mainWeather: String?
    var description: String?
    var icon: UIImage?
    var temperature: Float?
    var feelsLike: Float?
    var humidity: Int?
}

