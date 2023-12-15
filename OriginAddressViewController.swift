//
//  OriginAddressViewController.swift
//  TesterRoadTripPlanner
//
//  Created by Justin Guilarte on 5/17/23.
//

import UIKit
import MapKit
import CoreLocation

class OriginAddressViewController: UIViewController {
    
    @IBOutlet var originSearchBar: UISearchBar!
    private var results = [MKLocalSearchCompletion]()
    let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = ""
    @IBOutlet var originAddressTable: UITableView!
    var startingAddress = MKLocalSearchCompletion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
        
        self.originAddressTable.delegate = self
        self.originAddressTable.dataSource = self
        originSearchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDestinationAddressEntry" {
            if let destinationViewController = segue.destination as? DestinationAddressViewController {
                destinationViewController.originCoordinates = sender as? CLLocationCoordinate2D
            }
        }
    }
    
    private func performSegueToDestination() {
        let geocoder = CLGeocoder()
        let address = startingAddress.title
        
        geocoder.geocodeAddressString(address) { response, error in
            guard let placemark = response?.first,
                  let location = placemark.location else { return }
            
            let coordinate = location.coordinate
            self.performSegue(withIdentifier: "ToDestinationAddressEntry", sender: coordinate)
        }
    }
    
}
    




//MARK: - Extensions

extension OriginAddressViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        queryFragment = searchText
        searchCompleter.queryFragment = queryFragment
        originAddressTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        originAddressTable.reloadData()
    }
    
}

extension OriginAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchCompleter.isSearching {
            return results.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if searchCompleter.isSearching {
            cell.textLabel?.text = results[indexPath.row].title
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        startingAddress = results[indexPath.row]
        performSegueToDestination()

    }
    
    
}


extension OriginAddressViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
        
    }
}

