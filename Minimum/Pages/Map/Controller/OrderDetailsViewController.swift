//
//  OrderDetailsViewController.swift
//  Minimum
//
//  Created by Edward Chandra on 26/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class OrderDetailsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextViewDelegate {

    
    @IBOutlet weak var userMapView: MKMapView!
    
    @IBOutlet weak var addPictureImageView: UIImageView!
    
    @IBOutlet weak var notesTV: UITextView!
    
    @IBOutlet weak var orderButton: UIButton!
    
    @IBOutlet weak var locationPickedLabel: UILabel!
    
    //MARK: Variables
    //variables to be used
    private var userDestination: MKMapItem?
    private var locationManager: CLLocationManager = CLLocationManager()
    private var userLocation: CLLocation?
    
    var pointAnnotation : CustomAnnotation!
    var pinAnnotationView : MKAnnotationView?
    
    var latitudeData: Double = 0.0
    var longitudeData: Double = 0.0
    
    var address: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Ringkasan Pesanan"
        
        notesTV.delegate = self
        

        customizeElements()
        
        setupMap()
        
        annotationPoint()
        
        locationPickedLabel.text = address
    }
    
    //MARK: Map Setup
    //setting up the map
    func setupMap() {
        
        //Set delegate to view controller
        userMapView.delegate = self
        
        //map view showing user location
        userMapView.showsUserLocation = false
        
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
    
    func center(onRoute route: [CLLocationCoordinate2D], fromDistance km: Double) {
        let center = MKPolyline(coordinates: route, count: route.count).coordinate
        userMapView.setCamera(MKMapCamera(lookingAtCenter: center, fromDistance: km * 1000, pitch: 0, heading: 0), animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        userLocation = locations[0]
        
    }
    
    //MARK: Function run if there's an error in the Location Manager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        //print the error description
        print(error.localizedDescription)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
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
    
    func annotationPoint(){
        let annotation = MKPointAnnotation()
        
        let coordinate = CLLocationCoordinate2D(latitude: latitudeData, longitude: longitudeData)
        
        annotation.coordinate = coordinate
        annotation.title = "Pick Up Location"
        
        for annotationPoint in userMapView.annotations{
            if annotationPoint.title == "Pick Up Location" {
                self.userMapView.removeAnnotation(annotationPoint)
                self.userMapView.removeAnnotations(userMapView.annotations)
                self.userMapView.removeOverlays(userMapView.overlays)
            }
        }
        
        self.userMapView.addAnnotation(annotation)
        
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: CLLocationDistance(1000), longitudinalMeters: CLLocationDistance(1000))
        userMapView.setRegion(coordinateRegion, animated: true)
    }
    
    func customizeElements(){
        orderButton.layer.cornerRadius = 11
        notesTV.layer.cornerRadius = 2
        notesTV.layer.borderColor = UIColor.lightGray.cgColor
        notesTV.layer.borderWidth = 0.5
        
        notesTV.text = "Tambahkan Catatan Anda Disinii"
        notesTV.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTV.textColor == UIColor.lightGray {
            notesTV.text = nil
            notesTV.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if notesTV.text.isEmpty {
            notesTV.text = "Tambahkan Catatan Anda Disinii"
            notesTV.textColor = UIColor.lightGray
        }
    }
    

}
