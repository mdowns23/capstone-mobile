//
//  CarInfoViewController.swift
//  TesterRoadTripPlanner
//
//  Created by Justin Guilarte on 5/19/23.
//

import UIKit
import MapKit

class CarInfoViewController: UIViewController {

    
    @IBOutlet var tankSize: UITextField!
    @IBOutlet var mpgLevel: UITextField!
    
    //@IBOutlet var toMapViewButton: UIButton!
    //@IBOutlet var toListViewButton: UIButton!
    @IBOutlet var gasTypesDropdown: UIButton!
    @IBOutlet var gasLevelDropdown: UIButton!
    
    var user = UserInformation()
    
    var originAddress = MKLocalSearchCompletion()
    var destinationAddress = MKLocalSearchCompletion()
    
    var originCoordinates: CLLocationCoordinate2D?
    var destinationCoordinates: CLLocationCoordinate2D?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFuelTypes()
        setupGasLevels()
        loadUserInformation()
        setupTextFields()
        
        //userInformationValueCheck()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helpers
    
    
    //Test to ensure that the data is being added to the User object
    private func userInformationValueCheck() {
        print("The following is user information: ")
        print("Origin Address: \(user.originAddress)")
        print("Destination Address: \(user.destinationAddress)")
        print("Tank size: \(user.tankSize)")
        print("MPG: \(user.MPG)")
        print("Fuel level: \(user.fuelLevel)")
        print("Fuel type: \(user.fuelType)")
        print("Origin Coordinates: \(user.originCoordinate)")
        print("Destination Coordinates: \(user.destinationCoordinate)")
    }
    
    private func loadUserInformation() {
        self.user.originAddress = originAddress
        self.user.destinationAddress = destinationAddress
        self.user.originCoordinate = originCoordinates!
        self.user.destinationCoordinate = destinationCoordinates!
        
    }
    
    private func setupFuelTypes() {
        let optionClosure = {(action : UIAction) in
            //print("This is the current fuel type: \(action.title)")
            self.user.fuelType = action.title
            self.userInformationValueCheck()
        }
        
        gasTypesDropdown.menu = UIMenu (children: [
            UIAction(title:"Regular", state: .on, handler: optionClosure),
            UIAction(title:"MidGrade", state: .on, handler: optionClosure),
            UIAction(title:"Premium", state: .on, handler: optionClosure),
            UIAction(title:"Diesel", state: .on, handler: optionClosure)
        
        ])
    }
    
    //TODO: Check to see if you can change to INT
    private func setupGasLevels() {
        let optionClosure = {(action : UIAction) in
            //print("This is the current gas level: \(action.title)")
            self.user.fuelLevel = action.title
            //self.userInformationValueCheck()
        }
        
        gasLevelDropdown.menu = UIMenu (children: [
            UIAction(title:"100", state: .on, handler: optionClosure),
            UIAction(title:"75", state: .on, handler: optionClosure),
            UIAction(title:"50", state: .on, handler: optionClosure),
            UIAction(title:"25", state: .on, handler: optionClosure)
        
        ])
    }
    
    private func setupTextFields() {
        tankSize.delegate = self
        mpgLevel.delegate = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Sends to list view
        if segue.identifier == "ToListView" {
            let listView = segue.destination as? DIrectionsListViewController
            listView?.user = user
        }
        else if segue.identifier == "ToMapView" {
            let mapView = segue.destination as? MapViewController
            user.distanceThreshold = Double(user.MPG) * (Double(user.tankSize) / 2.0)
            mapView?.user = user
        }
        //Send to map view
            
            
    }
    
    func getLocation(from address: MKLocalSearchCompletion, completion: @escaping (_ location: CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        let addressLookup = address.title.appending(address.subtitle)
        geocoder.geocodeAddressString(addressLookup) { (placemarks, error) in
            guard let placemarks,
                  let location = placemarks.first?.location?.coordinate else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
    
    
    //MARK: - Actions
    
    @IBAction func mpgGetVal(_ sender: UITextField) {
        let temp = sender.text ?? "0"
        let userMpg = Int(temp)
        
        user.MPG = userMpg!
        
        //TODO: Create an alert if the MPG is below 0
        userInformationValueCheck()
    }
    
    
    @IBAction func getTanksizeVal(_ sender: UITextField) {
        let temp = sender.text ?? "0"
        let userTanksize = Int(temp)
        
        user.tankSize = userTanksize!
    
        //TODO: Create an alert if the tank size is below 0
        userInformationValueCheck()
    }
    
}




    //MARK: - Extensions

extension CarInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

