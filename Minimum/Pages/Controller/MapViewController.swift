//
//  MapViewController.swift
//  Minimum
//
//  Created by Jessica Jacob on 22/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//implementing UIViewController for the UI, MKMapViewDelegate for the MapView, and LocationManager to manage the current location
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //MARK: IBOutlets
    //outlets to be used
    @IBOutlet weak var userMapView: MKMapView!
    
    //MARK: Variables
    //variables to be used
    private var userDestination: MKMapItem?
    private var locationManager: CLLocationManager = CLLocationManager()
    private var userLocation: CLLocation?
    
    //MARK: View Did Load
    //when the ui elements is being loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        //calling the setupMap function to setting up the map
        setupMap()
        
        //calling the getRouteDirection function to start showing the route direction to the destination
        getRouteDirection()
    }
    
    //MARK: Map Setup
    //setting up the map
    func setupMap() {
        
        //Set delegate to view controller
        userMapView.delegate = self
        
        //map view showing user location
        userMapView.showsUserLocation = true
        
        //user location default value used
        userLocation = CLLocation(latitude: -6.301492, longitude: 106.652992)
        
        //accuracy of the location set to best,
        //developer can set it to 3 metres, 10 metres, etc of accuracy.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //set location manager delegate to view controller
        locationManager.delegate = self
        
        //check the authorization status by the user
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            //start updating the location of the current position
            locationManager.startUpdatingLocation()
        } else {
            
            //request permission to the user when is going to use it in the foreground
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //MARK: Location Manager when Updated
    //function run when location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //getting location of current position and passing the data to userLocation variable
        if let location = locations.last{
            self.userLocation = location
        }
    }
    
    //MARK: Get Route Direction
    //getting route direction to show in the map
    func getRouteDirection() {
        
        //request the direction
        let request = MKDirections.Request()
        
        //getting the starting point of the direction
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: -6.301492, longitude: 106.652992), addressDictionary: nil))
        
        //setting the destination that the direction headed to
        userDestination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: -6.298421, longitude: 106.669778), addressDictionary: nil))
        
        //optional binding to prevent fatal error when return nil
        if let destination = userDestination {
            
            //getting the destination point of the direction
            request.destination = destination
        }
        
        //disable the alternate route that direction can show
        request.requestsAlternateRoutes = false
        
        //setting the direction with request declared above
        let directions = MKDirections(request: request)
        
        //calculate the route for the direction
        directions.calculate { (response, error) in
            
            //check if there's an error
            if let error = error {
                
                //print the cause description of the error
                print(error.localizedDescription)
            } else {
                
                //optional binding to prevent fatal error when return nil
                if let response = response {
                    
                    //calling the show route function to start showing the route
                    self.showRoute(response)
                }
            }
        }
    }
    
    //MARK: Function to Show Direction Route
    func showRoute(_ response: MKDirections.Response) {
        
        //looping the route that is generated in the response as many as the routes generated
        for route in response.routes {
            
            //adding overlay to show the route above the road
            userMapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
           
            //Changes the currently visible portion of the map and optionally animates the change.
            userMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            //looping through the steps in the route that is needed to arrive to the destination
            for step in route.steps {
                
                //print the steps in the console
                print(step.instructions)
            }
        }
    }
    
    //MARK: Function run if there's an error in the Location Manager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        //print the error description
        print(error.localizedDescription)
    }
    
    //MARK: Function to Overlay the Road
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        //representation of the polyline overlay object
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        //setting the stroke color as red
        renderer.strokeColor = .red
        
        //setting the thickness of the line to 3
        renderer.lineWidth = 3.0
        
        //return the value of renderer constant
        return renderer
    }
    
    //MARK: Button Action
    //action when button clicked
    @IBAction func currentLocationAction(_ sender: Any) {
        
        //getting the coordinate of user location
        if let coordinate = userLocation?.coordinate {
            
            //When user click the button, the current location shown with latitudinal and longitudinal meters of 1000
            let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                      latitudinalMeters: CLLocationDistance(1000), longitudinalMeters: CLLocationDistance(1000))
            
            //setting the region view of 1000 radius
            userMapView.setRegion(coordinateRegion, animated: true)
        }
    }
    

}
