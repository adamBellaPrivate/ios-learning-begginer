//
//  CustomMarkerView.swift
//  AppleMapExample
//
//  Created by Ádám Bella on 1/28/18.
//  Copyright © 2018 Ádám Bella. All rights reserved.
//

import Foundation
import MapKit

class CustomMarkerView : MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let bar = newValue as? Bar else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: 5, y: -5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

            markerTintColor = .green
            if let charachter = bar.title?.first {
                glyphText = String(charachter)
            }else{
                glyphText = ""
            }
            //glyphImage
        
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = bar.description
            detailCalloutAccessoryView = detailLabel
        }
    }
}
