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

final class WeatherViewController: UIViewController, UISearchBarDelegate {
    
    private var viewModel = WeatherViewModel()
    
    private var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()
    fileprivate var resultsViewController = LocationSearchResultViewController()
    let citySearchView = UIView()
    
    private let scrollView = UIScrollView()
    
    private lazy var stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    var stackViewConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        setupView()
        setupAppleMap()
        viewModel.fetchLastLocation { result in
            self.refreshStackView()
        }
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(citySearchView)
        citySearchView.edgesToSuperview(excluding: [.bottom], insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), usingSafeArea: true)
        citySearchView.height(56)
        searchController.searchBar.searchTextField.placeholder = NSLocalizedString("Enter a search term", comment: "")
        searchController.searchBar.delegate = self
        
        view.addSubview(scrollView)
        scrollView.edgesToSuperview(excluding: [.top], insets: .uniform(16), usingSafeArea: true)
        scrollView.topToBottom(of: citySearchView)
        
        setupStackView()
    }
    
    private func setupStackView() {
        scrollView.addSubview(stackView)
        stackView.edgesToSuperview()
        
        if UIDevice.current.orientation.isPortrait {
            stackViewConstraint = stackView.widthToSuperview()
            stackView.axis = .vertical
        } else if UIDevice.current.orientation.isLandscape {
            stackViewConstraint = stackView.heightToSuperview()
            stackView.axis = .horizontal
        }
    }
    
    private func refreshStackView() {
        stackView.subviews.forEach { $0.removeFromSuperview() }
        
        if let currentLocWeatherData = viewModel.getCurrentLocationWeatherData() {
            let card = WeatherCardView(with: currentLocWeatherData, isCurrentLocation: true)
            stackView.insertArrangedSubview(card, at: 0)
        }
        viewModel.getWeatherData().forEach { weatherModel in
            let card = WeatherCardView(with: weatherModel)
            stackView.insertArrangedSubview(card, at: 0)
        }
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    private func setupAppleMap() {
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        // Auto Completion
        resultsViewController.edgesForExtendedLayout = [.top]
        resultsViewController.extendedLayoutIncludesOpaqueBars = false
        resultsViewController.handleSearchDelegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        
        // assign the delegate for changes in searchbar text
        searchController.searchBar.delegate = resultsViewController
        searchController.searchBar.searchBarStyle = .minimal
        
        citySearchView.addSubview(searchController.searchBar)
        NSLayoutConstraint.activate([
            searchController.searchBar.topAnchor.constraint(equalTo: citySearchView.topAnchor),
            searchController.searchBar.leftAnchor.constraint(equalTo: citySearchView.leftAnchor),
            searchController.searchBar.rightAnchor.constraint(equalTo: citySearchView.rightAnchor),
            searchController.searchBar.bottomAnchor.constraint(equalTo: citySearchView.bottomAnchor)
        ])
        
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchController.searchBar.frame.size.width = citySearchView.frame.size.width
        searchController.searchBar.frame = searchController.searchBar.frame
    }
    
}

//MARK: - User Location
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latLng: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        viewModel.fetchCurrentLocWeather(coordinate: latLng) { result in
            self.refreshStackView()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
}

//MARK: - Search Places Selection
extension WeatherViewController: HandleSearchDelegate {
    func didSelectPlace(placemark: MKPlacemark) {
        searchController.isActive = false
        viewModel.setLastLocation(coordinate: placemark.coordinate)
        viewModel.fetchWeather(coordinate: placemark.coordinate) { result in
            self.refreshStackView()
        }
    }
}

// MARK: Handle orientation change
extension WeatherViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        stackView.removeFromSuperview()
        setupStackView()
    }
}
