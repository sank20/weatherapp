//
//  LocationSearchResultViewController.swift
//  weatherapp
//
//  Created by Sanket Pimple on 3/7/23.
//

import UIKit
import MapKit

protocol HandleSearchDelegate {
  func didSelectPlace(placemark: MKPlacemark)
}

class LocationSearchResultViewController: UITableViewController {

    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()

    var handleSearchDelegate: HandleSearchDelegate?

    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchCompleter.delegate = self
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }
}

extension LocationSearchResultViewController: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    searchResults = completer.results
    activityIndicator.stopAnimating()

    tableView.reloadData()
  }

  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    activityIndicator.stopAnimating()
    print("Error: ", error.localizedDescription)
  }
}

extension LocationSearchResultViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchCompleter.queryFragment = searchText
    activityIndicator.startAnimating()
  }
}

// MARK: - Table view data source
extension LocationSearchResultViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResults.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let searchResult = searchResults[indexPath.row]
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
    cell.textLabel?.text = searchResult.title
    cell.detailTextLabel?.text = searchResult.subtitle
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let completion = searchResults[indexPath.row]

    let searchRequest = MKLocalSearch.Request(completion: completion)
    let search = MKLocalSearch(request: searchRequest)
    search.start { (response, _) in
      guard let placemark = response?.mapItems[0].placemark else { return }
      self.handleSearchDelegate?.didSelectPlace(placemark: placemark)
    }
  }
}
