//
//  TripInfoViewController.swift
//  TesterRoadTripPlanner
//
//  Created by Justin Guilarte on 5/31/23.
//

import UIKit
import MapKit
import CoreLocation

class TripInfoViewController: UIViewController {

    var gasPrices = [3.14, 3.57, 3.12, 3.41, 3.61, 4.32, 4.21, 4.54, 5.03, 4.66, 4.08, 3.81, 3.93, 3.79, 3.32]
    var user = UserInformation()
    var gasStationCoordinates: [CLLocationCoordinate2D] = []
    var gasStations: [MKMapItem] = []
    @IBOutlet var listOfGasStations: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInitalValues()

        // Do any additional setup after loading the view.
        listOfGasStations.delegate = self
        listOfGasStations.dataSource = self
        listOfGasStations.reloadData()
        //checkInitalValues()
        //getGasPrices()
    }
    
    //MARK: - Helpers
    
    private func checkInitalValues(){
        print("First going to chek gasStationCoordinates:")
        for gasStationCoordinate in gasStationCoordinates {
            print("GASCOORD:\(gasStationCoordinate)")
        }
        print("Now go through list of gas stations")
        for gasStation in gasStations{
            print(gasStation)
        }
        print(user.fuelType)
    }
  
    
    
    
//    private func getGasPricesTmp(){
//        for coord in gasStationCoordinates{
//            let randPrice = prics.randomElement()
//            print(randPrice)
//        }
//        
//    }
    
//    private func getGasPrices() {
//        var lati1 = ""
//        var lngi1 = ""
//        guard let url = URL(string: "https://www.gasbuddy.com/gaspricemap/county?lat=\(lati1)&lng=\(lngi1)&usa=true") else {
//            print("Invalid API URL")
//            return
//        }
//        var gType = 0
//        if user.fuelType == "Regular"{
//            gType = 1
//        }else if(user.fuelType == "MidGrade"){
//            gType = 2
//        }else if(user.fuelType == "Premium"){
//            gType = 3
//        }else{
//            gType = 4
//        }
//
//        // Create the request
//
//
//
//        for gasCoord in gasStationCoordinates{
//
//            var lat = gasCoord.latitude
//            //lat = lat - 0.0005
//            print("Printing lat: \(lat)")
//
//            var lng = gasCoord.longitude
//            //lng = lng - 0.0005
//
//            guard let url1 = URL(string:  "https://www.gasbuddy.com/gaspricemap/county?lat=\(lat)&lng=\(lng)&usa=true")else {
//                print("invalid url")
//                return
//            }
//
//            var request = URLRequest(url: url1)
//            request.httpMethod = "POST"
//
//            print("Printing lng: \(lng)")
//
//            var lat1 = gasCoord.latitude
//            lat1 = lat1 + 0.0005
//
//            print("Printing lat1: \(lat1)")
//
//            var lng1 = gasCoord.longitude
//            lng1 = lng1 + 0.0005
//
//            print("Printing lng1: \(lng1)")
//
//            // should send an array of types as well, will hard code for now
//            let parameters: [String: Any] = [
//                "fuelTypeId": gType,
//                "height": 600,
//                "maxLat": lat1,
//                "maxLng": lng1,
//                "minLat": lat,
//                "minLng": lng,
//                "width": 818
//            ]
//
//
//
//            //print("Parameters: \(parameters)")
//            //request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            let session = URLSession.shared
//            let task = session.dataTask(with: request){ (data, response, error) in
//
//                if let error = error{
//                    print("Error: \(error)")
//                    throw error
//                }
//                if let data = data {
//                    if let responseString = String(data:data, encoding: .utf8){
//                        print("Response: \(responseString)")
//                        //let jsonS = responseString.replacingOccurrences(of: "[[]]", with: "")
//                        if let split = responseString.components(separatedBy: ","){
//
//                            if let split2 = split[3].components(separatedBy: ":"){
//
//                                //if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
//                                if let price = split2[1] {
//                                    print("Price: \(price)")
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            task.resume()
//
//        }
    }

//MARK: - Extension


extension TripInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gasStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        let station = gasStations[indexPath.row]
        
        var tripInfoString = "Name: " + station.name! + "\n" + "Address: " + station.placemark.title!
        tripInfoString += "\n" +  "Price: " + String(gasPrices.randomElement() ?? 3.25)
        
            
        cell.textLabel?.text = tripInfoString
        //cell.textLabel?.text = "Name: " + station.name! + "\n" + "Address: " + station.placemark.title!
        //cell.textLabel?.text = "\n" + "Price: " + String(gasPrices.randomElement() ?? 3.25)
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    
}
