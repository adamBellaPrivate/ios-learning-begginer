//
//  ViewController.swift
//  AppleMapExample
//
//  Created by Ádám Bella on 1/28/18.
//  Copyright © 2018 Ádám Bella. All rights reserved.
//

import UIKit
import MapKit


extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Bar else { return nil }

        if annotation.isDefaultView {
            let identifier = "annotation"
            var view: MKMarkerAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return view
        }else{
            var view: CustomMarkerView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
                as? CustomMarkerView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = CustomMarkerView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            }
            return view
        }
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Bar
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let initialLocation = CLLocation(latitude: 47.762165, longitude: 12.647334)
    private let locationManager = CLLocationManager()
    fileprivate let regionRadius: CLLocationDistance = 1000
    fileprivate let csapodCoordinate = CLLocationCoordinate2D(latitude: 47.520690,longitude: 16.925265)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthorizationStatus()
        centerMapOnLocation(location: initialLocation)
        configureMap()
        loadData()
    }
    
    fileprivate final func loadData(){
        let bar = Bar("Stachus Bar",address: "83324 Ruhpolding Hauptstraße 56", coordinate: CLLocationCoordinate2D(latitude: 47.762165, longitude: 12.647334))
        mapView.addAnnotation(bar)
        
        let restaurant = Bar("Restaurant Café & Lounge Die Welle",address: "83324 Ruhpolding Brander Str. 1", coordinate: CLLocationCoordinate2D(latitude: 47.757636, longitude: 12.649345), isDefaultView: false)
        mapView.addAnnotation(restaurant)
    }
    
    fileprivate func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    fileprivate func configureMap(){
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.register(CustomMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    fileprivate func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    fileprivate func navigateToUserLocation(){
       let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 2000, 2000)
       mapView.setRegion(region, animated: true)
    }
    
    @IBAction func actionToGoCity(_ sender: Any) {
         let fromCoordinate = mapView.userLocation.coordinate
         let urlString = "http://maps.apple.com/maps?saddr=\(fromCoordinate.latitude),\(fromCoordinate.longitude)&daddr=\(csapodCoordinate.latitude),\(csapodCoordinate.longitude)"
         guard let url = URL(string:urlString) else {return}
         if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
    }
    
    @IBAction func actionVisitCity(_ sender: Any) {
        let urlString = "http://maps.apple.com/maps?ll=\(csapodCoordinate.latitude),\(csapodCoordinate.longitude)"
        guard let url = URL(string:urlString) else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func actionNavigateToUserLocation(_ sender: Any) {
        navigateToUserLocation()
    }
}
