//
//  JSONParsing.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/4/23.
//

import Foundation

final class JSONParsing {
    static func parseCitiesJSON() -> [CityItem] {
        guard
          let url = Bundle.main.url(forResource: "usa_cities", withExtension: "json"),
          let data = try? Data(contentsOf: url)
        else { return [] }
        do {
          let cities = try JSONDecoder().decode([CityItem].self, from: data)
            return cities
        } catch {
          print(error)
            return []
          // Insert error handling here
        }
    }
}
