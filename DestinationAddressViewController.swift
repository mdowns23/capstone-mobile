//
//  DestinationAddressViewController.swift
//  TesterRoadTripPlanner
//
//  Created by Justin Guilarte on 5/18/23.
//

import UIKit
import MapKit

class DestinationAddressViewController: UIViewController {

    private var results = [MKLocalSearchCompletion]()
    private let searchCompleter = MKLocalSearchCompleter()
    var originAddress = MKLocalSearchCompletion()
    var destination = MKLocalSearchCompletion()
    
    var originCoordinates: CLLocationCoordinate2D?
    
    @IBOutlet var destinationAddress: UITableView!
    @IBOutlet var destinationSearchBar: UISearchBar!
    
    var queryFragment: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment

        self.destinationAddress.delegate = self
        self.destinationAddress.dataSource = self
        destinationSearchBar.delegate = self
        //originAddressChecker()
        
        //checkCoordinates()
        
    }
    
    private func performSegueToCarInformation() {
        let geocoder = CLGeocoder()
        let address = destination.title
        
        geocoder.geocodeAddressString(address) { response, error in
            guard let placemark = response?.first,
                  let location = placemark.location else { return }
            
            let coordinate = location.coordinate
            self.performSegue(withIdentifier: "ToCarInformationView", sender: coordinate)
        }
    }
    
    
    
    //Test function to ensure that the origin address
    private func originAddressChecker(){
        print(originAddress.title)
    }
    
    func checkCoordinates(){
        print("This is a test to see origin coordinates: \(originCoordinates!)")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCarInformationView" {
            let destinationViewController = segue.destination as? CarInfoViewController
            destinationViewController?.originCoordinates = originCoordinates
            destinationViewController?.destinationCoordinates = sender as? CLLocationCoordinate2D
        }
    }
    
}


//MARK: - Extensions

extension DestinationAddressViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        queryFragment = searchText
        searchCompleter.queryFragment = queryFragment
        destinationAddress.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        destinationAddress.reloadData()
    }
    
}

extension DestinationAddressViewController: UITableViewDelegate, UITableViewDataSource {
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
        destination = results[indexPath.row]
        performSegueToCarInformation()
        
    }
    
    
}


extension DestinationAddressViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
        
    }
}
