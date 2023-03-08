//
//  WeatherCardView.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/7/23.
//

import UIKit
import Kingfisher
import TinyConstraints

final class WeatherCardView: UIView {

    private var weatherModel: WeatherModel

    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 52, weight: .regular)
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .regular)
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    

    lazy var dateTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()

    lazy var feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    lazy var highLowTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    lazy var weatherDetailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    lazy var weatherImageView = UIImageView()
    lazy var weatherConditionLabel = UILabel()
    
    init(with weatherModel: WeatherModel, isCurrentLocation: Bool = false) {
        self.weatherModel = weatherModel
        super.init(frame: .zero)
        height(240)
        width(348)
        
        self.backgroundColor = isCurrentLocation ? .systemYellow : .systemGray5

        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.distribution = .equalCentering
        mainStackView.alignment = .center
        mainStackView.spacing = UIStackView.spacingUseSystem
        mainStackView.isLayoutMarginsRelativeArrangement = true
        self.addSubview(mainStackView)
        mainStackView.edgesToSuperview(insets: .uniform(16))
        
        
        //------Date Time------------
        if let timeStamp = weatherModel.timeStamp {
            dateTimeLabel.text = getDateTime(timestamp: timeStamp)
        }
        
        if let temperature = weatherModel.mainData.temperature {
            temperatureLabel.text = String(temperature) + " F"
        }
        
        cityLabel.text = weatherModel.city

        if let feelsLike = weatherModel.mainData.feelsLike {
            feelsLikeLabel.text = "Feels like: \(feelsLike) F"
        }
        
        if let minTemp = weatherModel.mainData.minTemp, let maxTemp = weatherModel.mainData.maxTemp {
            highLowTempLabel.text = "H:\(String(maxTemp))F  L:\(String(minTemp))F"
        }
        
        if !weatherModel.weatherInfo.isEmpty {
            weatherDetailLabel.text = weatherModel.weatherInfo[0].description.capitalized
        }
        
        let infoStackView = UIStackView(arrangedSubviews: [dateTimeLabel, cityLabel, temperatureLabel, feelsLikeLabel, highLowTempLabel, weatherDetailLabel])
        infoStackView.axis = .vertical
        
        //        ---------------------------image---------
        if !weatherModel.weatherInfo.isEmpty {
            let url = URL(string: "https://openweathermap.org/img/wn/\(weatherModel.weatherInfo[0].icon)@2x.png")
            weatherImageView.kf.setImage(with: url, placeholder: nil)
            
            weatherConditionLabel.textColor = .black
            weatherConditionLabel.sizeToFit()
            weatherConditionLabel.textAlignment = .center
            weatherConditionLabel.text = weatherModel.weatherInfo[0].mainWeather
        }
        
        let imageStackView = UIStackView(arrangedSubviews: [weatherImageView, weatherConditionLabel])
        imageStackView.axis = .vertical
        imageStackView.alignment = .center
        
        mainStackView.addArrangedSubview(infoStackView)
        mainStackView.addArrangedSubview(imageStackView)
        setShadowWithCornerRadius()
    }
    
    func setShadowWithCornerRadius() {
        self.layer.cornerRadius = 16.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        self.layer.shadowOpacity = 0.5
    }
    
    private func getDateTime(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short // Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium // Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}
