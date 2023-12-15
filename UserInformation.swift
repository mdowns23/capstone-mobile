//
//  UserInformation.swift
//  TesterRoadTripPlanner
//
//  Created by Justin Guilarte on 5/20/23.
//

import UIKit
import MapKit

struct UserInformation {
    //Starting address
    var originAddress: MKLocalSearchCompletion = MKLocalSearchCompletion()
    //Coordinate corresponding to origin address
    var originCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    //Destination
    var destinationAddress: MKLocalSearchCompletion = MKLocalSearchCompletion()
    //Destination Coordinate
    var destinationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    //Car tank size
    var tankSize: Int = 0
    //Total driving distance
    var totalDistance: Int = 0
    //Car mpg
    var MPG: Int = 0
    //Gas type that car takes
    var fuelType: String = "Regular"
    //Current level of fuel
    var fuelLevel: String = "100"
    //Distance Threshold
    var distanceThreshold = 0.0
    
    
    init(){}
    
}

