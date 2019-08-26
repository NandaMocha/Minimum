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
    @IBOutlet weak var navigateButton: UIButton!
    
    //MARK: Variables
    //variables to be used
    private var userDestination: MKMapItem?
    private var locationManager: CLLocationManager = CLLocationManager()
    private var userLocation: CLLocation?
    
    private var coordinateLatitude: [Double] = []
    private var coordinateLongitude: [Double] = []
    private var steps: Int = 0
    
    var latCurrent : Double = 0.0
    var longCurrent : Double = 0.0
    
    var pointAnnotation : CustomAnnotation!
    var pinAnnotationView : MKAnnotationView?
    
    var pointPickUp: MKPointAnnotation!
    var pinPickUp: MKAnnotationView?
    
    var userLocationIs: CLLocationCoordinate2D!
    
    var currentStep = 0
    
    var navigation: [CLLocationCoordinate2D] = []
    
    var latPinPoint: Double = 0.0
    var longPinPoint: Double = 0.0
    
    //MARK: View Did Load
    //when the ui elements is being loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        //calling the setupMap function to setting up the map
        setupMap()
        
        //calling the getRouteDirection function to start showing the route direction to the destination
        //getRouteDirection()
        addPinPoint()
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
//    //getting route direction to show in the map
//    func getRouteDirection() {
//
//        //request the direction
//        let request = MKDirections.Request()
//
//        //getting the starting point of the direction
//        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: -6.301492, longitude: 106.652992), addressDictionary: nil))
//
//        //setting the destination that the direction headed to
//        userDestination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: -6.298421, longitude: 106.669778), addressDictionary: nil))
//
//        //optional binding to prevent fatal error when return nil
//        if let destination = userDestination {
//
//            //getting the destination point of the direction
//            request.destination = destination
//        }
//
//        //disable the alternate route that direction can show
//        request.requestsAlternateRoutes = false
//
//        //setting the direction with request declared above
//        let directions = MKDirections(request: request)
//
//        //calculate the route for the direction
//        directions.calculate { (response, error) in
//
//            //check if there's an error
//            if let error = error {
//
//                //print the cause description of the error
//                print(error.localizedDescription)
//            } else {
//
//                //optional binding to prevent fatal error when return nil
//                if let response = response {
//
//                    //calling the show route function to start showing the route
//                    self.showRoute(response)
//                }
//            }
//        }
//    }
    
    func center(onRoute route: [CLLocationCoordinate2D], fromDistance km: Double) {
        let center = MKPolyline(coordinates: route, count: route.count).coordinate
        userMapView.setCamera(MKMapCamera(lookingAtCenter: center, fromDistance: km * 1000, pitch: 0, heading: 0), animated: false)
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
                
                coordinateLatitude.append(step.polyline.coordinate.latitude)
                coordinateLongitude.append(step.polyline.coordinate.longitude)
                
                navigation.append(CLLocationCoordinate2D(latitude: step.polyline.coordinate.latitude, longitude: step.polyline.coordinate.longitude))
                
                steps = step.polyline.pointCount
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
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        pointAnnotation = CustomAnnotation()
        pointAnnotation.pinCustomImageName = "point"
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: latCurrent, longitude: longCurrent)
        pinAnnotationView = MKAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
        
        userMapView.addAnnotation(pinAnnotationView!.annotation!)
        
        move(arrayOfSteps: navigation)
        
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
    
    @IBAction func navigateAction(_ sender: Any) {
        
        let sourceLocation = CLLocationCoordinate2D(latitude: userLocation?.coordinate.latitude ?? -6.301492, longitude: userLocation?.coordinate.longitude ?? 106.652992)
        //let destinationLocation = CLLocationCoordinate2D(latitude: -6.298421, longitude: 106.669778)
        
        let destinationLocation = CLLocationCoordinate2D(latitude: latPinPoint, longitude: longPinPoint)
        
            let pointDestination = MKPointAnnotation()
            pointDestination.coordinate = CLLocationCoordinate2D(
                latitude: destinationLocation.latitude,
                longitude: destinationLocation.longitude)
            
            let pinViewDestination = MKAnnotationView(annotation: pointDestination, reuseIdentifier: "destinationPin")
            
            userMapView.addAnnotation(pinViewDestination.annotation!)
            
            let centerLocation = CLLocationCoordinate2D(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)
            let regions = MKCoordinateRegion(center: centerLocation, latitudinalMeters: 250.0, longitudinalMeters: 250.0)
            
            //bring camera to this position
            self.userMapView.setRegion(regions, animated: true)
        
            createRoute(withSource: sourceLocation,
                        andDestination: CLLocationCoordinate2D(
                            latitude: destinationLocation.latitude,
                            longitude: destinationLocation.longitude))
            
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? MKAnnotation else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
    }
    
    //MARK: - Create Route
    func createRoute(withSource source: CLLocationCoordinate2D, andDestination destination: CLLocationCoordinate2D){
        
        
        let sourceMapItem = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        userMapView.removeOverlays(userMapView.overlays)
        
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            self.navigation.removeAll()
            let route = response.routes[0]//tujuan
            let totalStep = response.routes[0].steps
            
            for i in 0 ..< totalStep.count{
                print("Responses : \(response.routes[0].steps[i].polyline.coordinate)")
                self.navigation.append(response.routes[0].steps[i].polyline.coordinate)
            }
            
            self.userMapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            print("Cek Polyline: ", route.polyline.coordinate)
            
            
            let rect = route.polyline.boundingMapRect
            self.userMapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    //MARK:- Function Animate
    func  moveCar(_ arrayOfSteps : [CLLocationCoordinate2D]) {
        move(arrayOfSteps: arrayOfSteps)
        
    }
    
    func move(arrayOfSteps : [CLLocationCoordinate2D]){
        var timer = 0
        switch currentStep{
        case 0:
            timer = 1
        default:
            timer = 5
        }
        
        if self.currentStep < arrayOfSteps.count{
            UIView.animate(withDuration: TimeInterval(timer), animations: {
                self.pointAnnotation.coordinate = arrayOfSteps[self.currentStep]
            }, completion:  { success in
                
                // handle a successfully ended animation
                if self.currentStep < arrayOfSteps.count - 1{
                    self.currentStep += 1
                    self.move(arrayOfSteps: arrayOfSteps)
                }else{
                    print("Hei, Your Picker already Arrive!")
                }
            })
        }else{
            print("Hei, Your Picker already Arrive!")
        }
    }
    
    func addPinPoint(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.addPinPointGesture))
        userMapView.addGestureRecognizer(gesture)
    }
    
    @objc func addPinPointGesture(gestureReconizer: UILongPressGestureRecognizer){
        let location = gestureReconizer.location(in: userMapView)
        let coordinate = userMapView.convert(location, toCoordinateFrom: userMapView)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        annotation.title = "Pick Up Location"
        
        for annotationPoint in userMapView.annotations{
            if annotationPoint.title == "Pick Up Location" {
                self.userMapView.removeAnnotation(annotationPoint)
                self.userMapView.removeAnnotations(userMapView.annotations)
                self.navigation.removeAll()
                self.userMapView.removeOverlays(userMapView.overlays)
            }
        }
        
        self.userMapView.addAnnotation(annotation)
        
        latPinPoint = coordinate.latitude
        longPinPoint = coordinate.longitude
        
    }
    
    
}
