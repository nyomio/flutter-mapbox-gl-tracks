//
//  MyPlaceAnnotation.swift
//  MapboxMobileEvents
//
//  Created by Nagy istván on 2020. 07. 25..
//


import Foundation
import UIKit
import Mapbox

/**
     #A placek saját annoation osztálya, hogy a számunkra szükséges paraméterekkel jelenjenek meg
*/
class MyPlaceAnnotation: MGLAnnotationView {
    var identifier: String = ""
    var title: String = ""
    var color: String? = ""
    var group: String? = ""
    var coordinate: CLLocationCoordinate2D? = nil
    
}
