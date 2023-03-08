//
//  ViewController.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/7/23.
//

import UIKit
import MapKit
import CoreLocation

//TODO: Seaprate out uisearchbardelegate to an extension
class WeatherViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {

    private var viewModel = WeatherViewModel()
    private var citiesList: [CityItem] = JSONParsing.parseCitiesJSON()
    private var isWeatherFetched: Bool = false
    private var locationManager: CLLocationManager?

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
//        fetchWeather()
        view.backgroundColor = .systemBackground
        searchController.searchBar.searchTextField.placeholder = NSLocalizedString("Enter a search term", comment: "")
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let whitespaceCharacterSet = CharacterSet.whitespaces
   
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

