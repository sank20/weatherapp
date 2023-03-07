//
//  WeatherCardView.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/7/23.
//

import UIKit
import Kingfisher
//height: 240
//width: 320
class WeatherCardView: UIView {

    private var weatherViewModel: WeatherViewModel
    
    lazy var temperatureLabel = UILabel(frame: .zero)
    lazy var dateTimeLabel = UILabel(frame: .zero)
    lazy var feelsLikeLabel = UILabel(frame: .zero)
    lazy var hightLowTempLabel = UILabel(frame: .zero)
    
    lazy var weatherIcon = UIImageView()
    lazy var weatherConditionLabel = UILabel()
     
    init(with weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
