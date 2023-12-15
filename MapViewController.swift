//
//  MapViewController.swift
//  TesterRoadTripPlanner
//
//  Created by Justin Guilarte on 5/19/23.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {
    
    
    var user = UserInformation()
    var userLocation: CLLocationManager!
    var currentRoute: MKRoute?
    var currentStepIndex = 0
    
    //Whole distance of route
    var distanceTraveled: CLLocationDistance = 0.0
    static var listOfGasCoordinates: [CLLocationCoordinate2D] = []
    var listOfGasStations: [MKMapItem] = []
    var gasStationCoordinates: CLLocationCoordinate2D?
    
    //mapView
    @IBOutlet var directionsMapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        directionsMapView.delegate = self
        
        userLocation = CLLocationManager()
        userLocation.requestWhenInUseAuthorization()
        
        
        getDirections()
        printGasStationCoordinate()
        setOriginAndDestination()
        
        //TODO: Need to make destination annotation
        
        

        
        //directionsMapView.showsUserLocation = true
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToTripInfoView" {
            if let destinationViewController = segue.destination as? TripInfoViewController {
                destinationViewController.user = self.user
                destinationViewController.gasStationCoordinates = MapViewController.listOfGasCoordinates
                destinationViewController.gasStations = self.listOfGasStations
            }
        }
    }
    
    private func setOriginAndDestination(){
        let originAnnotation = MKPointAnnotation()
        
        originAnnotation.coordinate = user.originCoordinate
        originAnnotation.title = "\(user.originAddress.title)"
        originAnnotation.subtitle = "\(user.originAddress.subtitle)"
        self.directionsMapView.addAnnotation(originAnnotation)
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = user.destinationCoordinate
        destinationAnnotation.title = "\(user.destinationAddress.title)"
        destinationAnnotation.subtitle = "\(user.destinationAddress.subtitle)"
        self.directionsMapView.addAnnotation(destinationAnnotation)

    }
    


    func getDirections() {
        let request = MKDirections.Request()
        let sourcePlacemark = MKPlacemark(coordinate: user.originCoordinate)
        request.source = MKMapItem(placemark: sourcePlacemark)
        
        let destPlaceMark = MKPlacemark(coordinate: user.destinationCoordinate)
        request.destination = MKMapItem(placemark: destPlaceMark)
        
        request.transportType = [.automobile]
        
        let directions = MKDirections(request: request)
        directions.calculate() { response, error in
            guard let response = response else {
                print("DEBUG: Problem with getDirections(): \(error?.localizedDescription)")
                return
            }
            
            
            let distanceInterval: CLLocationDistance = self.user.distanceThreshold  * 1609.34// Set the distance interval for placing placemarks
            var distanceTraveled: CLLocationDistance = 0
            
            
            for route in response.routes {
                self.directionsMapView.addOverlay(route.polyline)
                
                let mapRect = route.polyline.boundingMapRect
                self.directionsMapView.setRegion(MKCoordinateRegion(mapRect), animated: true)
                
                let polyline = route.polyline
                let pointCount = polyline.pointCount
                
                //Array
                
                
                for i in 0..<pointCount-1 {
                    let coordinate1 = polyline.points()[i].coordinate
                    let coordinate2 = polyline.points()[i + 1].coordinate
                    
                    let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
                    let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
                    
                    let distance = location1.distance(from: location2)
                    distanceTraveled += distance
                    
                    while distanceTraveled >= distanceInterval {
                        let fraction = (distanceTraveled - distanceInterval) / distance
                        //Interpolated coordinate is where the placemark is
                        let interpolatedCoordinate = CLLocationCoordinate2D.interpolate(from: coordinate1, to: coordinate2, fraction: fraction)
                        
                        //self.searchGasStations(coordinate: interpolatedCoordinate)
                        
                        MapViewController.listOfGasCoordinates.append(interpolatedCoordinate)
                        
                        
                        distanceTraveled -= distanceInterval
                    }
                }
                //This works
                //self.printGasStationCoordinate()
                
                for gasstation in MapViewController.listOfGasCoordinates {
                    self.searchGasStations(station: gasstation)
                }
                
                
                
                
            }
        }
    }
    
    
    private func printGasStationCoordinate(){
        for coordinate in MapViewController.listOfGasCoordinates{
            print("This is from the printGasStation function: \(coordinate.latitude)")
        }
    }
    
    
    private func searchGasStations(station coordinate: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "gas station"
        request.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let items = response?.mapItems else {
                print("DEBUG: Error in checking gas stations \(error?.localizedDescription)")
                return
            }
            //print("This is the gas station coordinate: \(items[0].placemark.coordinate)")
            self.listOfGasStations.append(items[0])
    
            self.createAnnotation(annotation: items[0])
        }
        
    }
    
    
    
    private func createAnnotation(annotation item: MKMapItem) {
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = item.placemark.coordinate
        annotation1.title = item.name
        annotation1.subtitle = item.name
        self.directionsMapView.addAnnotation(annotation1)
    }
    
    
    
//    func displayCurrentStep() {
//        guard let currentRoute = currentRoute else {return}
//        if currentStepIndex >= currentRoute.steps.count {return}
//        let step = currentRoute.steps[currentStepIndex]
//
//        instructionsLabel.text = step.instructions
//        distanceLabel.text = "\(distanceConverter(distance: step.distance))"
//
//        if step.notice != nil {
//            noticeLabel.isHidden = false
//            noticeLabel.text = step.notice
//        }
//        else {
//            noticeLabel.isHidden = true
//        }
//
//        previousButton.isEnabled = currentStepIndex > 0
//        nextButton.isEnabled = currentStepIndex < (currentRoute.steps.count - 1)
//
//        let padding = UIEdgeInsets(top: 40, left: 40, bottom: 100, right: 40)
//        directionsMapView.setVisibleMapRect(step.polyline.boundingMapRect, edgePadding: padding, animated: true)
//    }
//
//    func distanceConverter(distance: CLLocationDistance) -> String {
//        let lengthFormatter = LengthFormatter()
//        lengthFormatter.numberFormatter.maximumFractionDigits = 2
//        if NSLocale.current.usesMetricSystem {
//            return lengthFormatter.string(fromValue: distance / 1000, unit: .kilometer)
//        }
//        else {
//            return lengthFormatter.string(fromValue: distance / 1609.34, unit: .mile)
//        }
//    }
//
//
    
    func valueCheck(){
        print("Origin Coordinates: \(user.originCoordinate)")
        print("Destination Coordinates: \(user.destinationCoordinate)")
    }
 

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = .red
        return renderer
    }
}


extension CLLocationCoordinate2D {
    static func interpolate(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, fraction: Double) -> CLLocationCoordinate2D {
        let lat = from.latitude + (to.latitude - from.latitude) * fraction
        let lon = from.longitude + (to.longitude - from.longitude) * fraction
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
