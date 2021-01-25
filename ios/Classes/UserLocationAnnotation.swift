//
//  MyCustomPointAnnotation.swift
//  MapboxMobileEvents
//
//  Created by Nagy istván on 2020. 07. 25..
//


import Foundation
import UIKit
import Mapbox
/**
     #A telefon mint tracker saját annoation osztálya, hogy meg tudjuk jeleníteni a felhasználó egyedi profilképét
*/

class UserLocationAnnotation: MGLPointAnnotation {
    var image: String? = ""
    var identifier: String = ""
    var color: String? = ""
    var group: String? = ""
    var size: Int = 50
    var uiimage: UIImage = UIImage()
}
