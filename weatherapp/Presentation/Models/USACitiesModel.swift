//
//  UsaCitiesModel.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/4/23.
//

import Foundation

struct CityItem: Decodable {
    var cityName: String
    var stateName: String
    private enum CodingKeys: String, CodingKey {
        case cityName = "city"
        case stateName = "state"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cityName = try container.decode(String.self, forKey: .cityName)
        self.stateName = try container.decode(String.self, forKey: .stateName)
    }
}
