//
//  DIrectionsListViewController.swift
//  TesterRoadTripPlanner
//
//  Created by Justin Guilarte on 5/19/23.
//

import UIKit
import MapKit
import SwiftUI
import CoreLocation

class DIrectionsListViewController: UIViewController {
    
    var user = UserInformation()
    var route: MKRoute?
    var steps: [MKRoute.Step] = []
    
    @IBOutlet var directionsTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        userInfoTest()

        directionsTable.delegate = self
        directionsTable.dataSource = self
        
        getRoute(from: user.originCoordinate, to: user.destinationCoordinate) {route in
            DispatchQueue.main.async {
                self.route = route
                self.directionsTable.reloadData()
            }
        }
        
    }
    
    
//MARK: - Helpers
    //Checks to ensure that segue worked properly
    private func userInfoTest(){
        print("The following is user information FROM LIST VIEW: ")
        print("Origin Address: \(user.originAddress)")
        print("Destination Address: \(user.destinationAddress)")
        print("Tank size: \(user.tankSize)")
        print("MPG: \(user.MPG)")
        print("Fuel level: \(user.fuelLevel)")
        print("Fuel type: \(user.fuelType)")
        print("Origin Coordinates: \(user.originCoordinate)")
        print("Destination Coordinates: \(user.destinationCoordinate)")
    }
    

    func getRoute(from originLocation: CLLocationCoordinate2D, to destinationLocation: CLLocationCoordinate2D, completion: @escaping(MKRoute?) -> Void) {
        print("We got both coordinates: Origin: \(originLocation) and Destination \(destinationLocation)")
        
        let request = MKDirections.Request()
        let originPlacemark = MKPlacemark(coordinate: originLocation)
        let destinationPlacemark =  MKPlacemark(coordinate: destinationLocation)
        request.source = MKMapItem(placemark: originPlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile
        
        let direction = MKDirections(request: request)
        
        direction.calculate { response, error in
            if let error = error {
                print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                completion(nil)
                
            } else{
                if let route = response?.routes.first {
                    self.route = route
                    self.steps = route.steps
                    self.directionsTable.reloadData()
                    completion(route)
                }
                //self.directionsTable.reloadData()
            }
        }
        
    }
    
    
    
    
    
    
    
    
//MARK: - Actions
    

    
    

}

    
//MARK: - Extensions

extension DIrectionsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        let step = steps[indexPath.row]
        
        cell.textLabel?.text = step.instructions
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("This is the route information \(route)")
        return route?.steps.count ?? 0
    }
}
