//
//  WeatherViewModel.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/3/23.
//

import Foundation

class WeatherViewModel {
    let service: WeatherAPIRequest
    
//    TODO: Define all the values to set directly to UILabels on the screen
    //TODO: make object private if required
    private(set) var weatherObj: WeatherModel
    init(service: WeatherAPIRequest = WeatherAPIRequest(), weatherObj: WeatherModel = WeatherModel()) {
        self.service = service
        self.weatherObj = weatherObj
    }
}
