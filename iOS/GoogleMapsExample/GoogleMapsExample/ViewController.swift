//
//  ViewController.swift
//  GoogleMapsExample
//
//  Created by Ádám Bella on 1/29/18.
//  Copyright © 2018 Ádám Bella. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    @IBOutlet weak var mapContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initGoogleMaps()
    }
    
    func initGoogleMaps() {
        guard mapContainerView != nil, mapContainerView.subviews.count == 0 else {return}
       
        let camera = GMSCameraPosition.camera(withLatitude: 47.762169, longitude: 12.648700, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: mapContainerView.bounds, camera: camera)
        mapContainerView.addSubview(mapView)
        mapView.isMyLocationEnabled = true
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 47.762169, longitude: 12.648700)
        marker.title = "Ruhpolding"
        marker.snippet = "Deutschland"
        marker.map = mapView
    }
    
    @IBAction func showCsaponOnMap(_ sender: Any) {
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:
                "comgooglemaps://?center=47.520688,16.925214&zoom=14")!, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://");
        }
    }
}

