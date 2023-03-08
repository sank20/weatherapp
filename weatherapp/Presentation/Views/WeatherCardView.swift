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
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
//TODO: separate out every component in its own function
//        TODO: set font, color etc
//        TODO: find out best way to set data to the labels
        
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.distribution = .equalCentering
        mainStackView.alignment = .center
        mainStackView.spacing = UIStackView.spacingUseSystem
        mainStackView.isLayoutMarginsRelativeArrangement = true
        self.addSubview(mainStackView)
        
        self.backgroundColor = .systemGray5

        //------Date Time------------
//        self.addSubview(dateTimeLabel)
        if let timeStamp = weatherViewModel.weatherObj.timeStamp {
            dateTimeLabel.text = getDateTime(timestamp: timeStamp)
        }
        dateTimeLabel.textColor = .black
        dateTimeLabel.sizeToFit()

//        self.addSubview(temperatureLabel)
        if let temperature = weatherViewModel.weatherObj.mainData.temperature {
            temperatureLabel.text = String(temperature)
        }
        temperatureLabel.font = .systemFont(ofSize: 60, weight: .regular)
        temperatureLabel.textColor = .black
        temperatureLabel.sizeToFit()
 
//        self.addSubview(feelsLikeLabel)
        feelsLikeLabel.textColor = .black
        feelsLikeLabel.sizeToFit()
//        feelsLikeLabel.font = .systemFont(ofSize: 60, weight: .regular)
        if let feelsLike = weatherViewModel.weatherObj.mainData.feelsLike {
            feelsLikeLabel.text = String(feelsLike)
        }

//        self.addSubview(hightLowTempLabel)
       hightLowTempLabel.textColor = .black
       hightLowTempLabel.sizeToFit()
//        hightLowTempLabel.font = .systemFont(ofSize: 60, weight: .regular)
        
        if let minTemp = weatherViewModel.weatherObj.mainData.minTemp, let maxTemp = weatherViewModel.weatherObj.mainData.maxTemp {
            hightLowTempLabel.text = "H:\(String(maxTemp)) L:\(String(minTemp))"
        }
//        NSLayoutConstraint.activate([
//            hightLowTempLabel.topAnchor.constraint(equalTo: feelsLikeLabel.bottomAnchor)])
      
        let infoStackView = UIStackView(arrangedSubviews: [dateTimeLabel, temperatureLabel, feelsLikeLabel, hightLowTempLabel])
        infoStackView.axis = .vertical
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
//        infoStackView.spacing = UIStackView.spacingUseSystem
//        infoStackView.isLayoutMarginsRelativeArrangement = true
//        infoStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        mainStackView.addArrangedSubview(infoStackView)
        
        
        //        ---------------------------image---------
        if !weatherViewModel.weatherObj.weatherInfo.isEmpty {
            let url = URL(string: "https://openweathermap.org/img/wn/\(weatherViewModel.weatherObj.weatherInfo[0].icon)@2x.png")

            KF.url(url)
    //          .placeholder(placeholderImage)
    //          .setProcessor(processor)
              .loadDiskFileSynchronously()
              .fromMemoryCacheOrRefresh()
              .onSuccess { result in
                  print("image loaded successfully")
              }
              .onFailure { error in
                  print("image loading error: \(error)")
              }
              .set(to: weatherIcon)
            
            weatherConditionLabel.textColor = .black
            weatherConditionLabel.sizeToFit()
            weatherConditionLabel.textAlignment = .center
            weatherConditionLabel.text = weatherViewModel.weatherObj.weatherInfo[0].mainWeather
        }
        
        
       
        
        let imageStackView = UIStackView(arrangedSubviews: [weatherIcon, weatherConditionLabel])
        imageStackView.axis = .vertical
        imageStackView.alignment = .center
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
//        imageStackView.spacing = UIStackView.spacingUseSystem
//        imageStackView.isLayoutMarginsRelativeArrangement = true
//        imageStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        imageStackView.leadingAnchor.constraint(equalTo: infoStackView.trailingAnchor).isActive = true
//        imageStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        mainStackView.addArrangedSubview(imageStackView)
//        
        setShadowWithCornerRadius(corners: 16)
    }
    
    func setShadowWithCornerRadius(corners : CGFloat){
           self.layer.cornerRadius = corners
           self.layer.masksToBounds = false
           self.layer.shadowColor = UIColor.lightGray.cgColor
            self.layer.shadowOffset = .zero
           self.layer.shadowOpacity = 0.5
           self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.shadowRadius = 10
        self.layer.rasterizationScale = UIScreen.main.scale
    
           }
    
//    TODO: Move to utilities
    func getDateTime(timestamp: Double) -> String {
        
        let date = Date(timeIntervalSince1970: timestamp)
            let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
        return localDate
    }
}
