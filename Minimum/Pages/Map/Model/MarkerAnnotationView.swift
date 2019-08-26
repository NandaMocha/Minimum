//
//  MarkerAnnotationView.swift
//  Minimum
//
//  Created by Edward Chandra on 23/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import Foundation
import MapKit

class MarkerAnnotationView: MKAnnotationView{
    override var annotation: MKAnnotation?{
        willSet{
            guard let annotation = newValue as? CustomAnnotation else {return}
            image = UIImage(named: annotation.pinCustomImageName)
        }
    }
}
