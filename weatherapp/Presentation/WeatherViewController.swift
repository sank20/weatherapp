//
//  ViewController.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/7/23.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

//TODO: Remove all the print statements
//TODO: Seaprate out uisearchbardelegate to an extension
//TODO: Code formatting and indentation
class WeatherViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {

    private var viewModel = WeatherViewModel()
    private var citiesList: [CityItem] = JSONParsing.parseCitiesJSON()
    private var isWeatherFetched: Bool = false
    private var locationManager: CLLocationManager? // Ideally all location related code should be moved to a LocationService class. It can be made a singleton if required
    let userDefaults = UserDefaults.standard

    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
//      TODO: get current location and send to fetchWeather
//        if last location is stored, get that, else, show weather for current location
        if let lastLocation = userDefaults.string(forKey: "last_location") {
            fetchWeather(city: lastLocation)
        } else {
            // TODO: fetchWeather for current user location
        }
//        fetchWeather()
        setupView()
    }

    func setupView() {
        view.backgroundColor = .systemBackground
        searchController.searchBar.searchTextField.placeholder = NSLocalizedString("Enter a search term", comment: "")
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
//        let scrollView = UIScrollView(frame: .zero)
//        view.addSubview(scrollView)
//
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//
//        scrollView.backgroundColor = .systemGreen
        
        let stackView = UIStackView()
//        scrollView.addSubview(stackView)
        stackView.axis = .vertical
//        stackView.distribution = .equalCentering
        stackView.spacing = 20
//        stackView.bounds = CGRectInset(stackView.frame, 10.0, 10.0)

        stackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//        ])

        let card = WeatherCardView(with: viewModel)
//        stackView.addArrangedSubview(card)
        view.addSubview(card)

        NSLayoutConstraint.activate([
            card.widthAnchor.constraint(equalToConstant: 365),
            card.heightAnchor.constraint(equalToConstant: 240),
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            card.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            card.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])

        card.translatesAutoresizingMaskIntoConstraints = false
        
//TODO: use uilabels and imageviews for now, rey scrollview and stackview later
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        guard let strippedCityString = searchController.searchBar.text?.trimmingCharacters(in: whitespaceCharacterSet) else { return  }
        // TODO: Add a check for internet connection here and everywhere else required
        if(validateCity(searchQuery: strippedCityString)) {
            print("City found!!")
            userDefaults.set(strippedCityString, forKey: "last_location")
            // TODO: add the WeatherModel instance as well in defaults. get that data if user is offline
            fetchWeather(city: strippedCityString)
        } else {
            //TODO: Show error - only usa cities allowed
            print("Error- wrong city!")
        }
    }
    
    func validateCity(searchQuery: String) -> Bool {
        return citiesList.contains(where: { $0.cityName.lowercased() == searchQuery.lowercased() })
    }
    
    func fetchWeather(city: String, unit: Unit = .imperial) {
        viewModel.service.getWeather(city: city, unit: unit) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let weather):
                    print("Fetched weather")
                    print(weather)
                    self?.isWeatherFetched = true
                    self?.viewModel = WeatherViewModel(weatherObj: weather)
                    self?.setupView()
                case .failure(let error):
                    self?.isWeatherFetched = true
                    print(error)
                }
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            if CLLocationManager.locationServicesEnabled() {
                locationManager?.delegate = self
                locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
                locationManager?.startUpdatingLocation()
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latLng: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(latLng.latitude) \(latLng.longitude)")
    }

}

