//
//  Bar.swift
//  AppleMapExample
//
//  Created by Ádám Bella on 1/28/18.
//  Copyright © 2018 Ádám Bella. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Bar: NSObject, MKAnnotation {
    fileprivate(set) var coordinate: CLLocationCoordinate2D
    fileprivate(set) var title : String? = ""
    fileprivate(set) var address = ""
    fileprivate(set) var isDefaultView = true
    
    init(_ title : String = "", address : String = "", coordinate: CLLocationCoordinate2D, isDefaultView : Bool = true) {
        self.title = title
        self.address = address
        self.coordinate = coordinate
        self.isDefaultView = isDefaultView
        super.init()
    }
    
    override var description: String {
        return "Title: \(title ?? ""), address: \(address)"
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: address]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
