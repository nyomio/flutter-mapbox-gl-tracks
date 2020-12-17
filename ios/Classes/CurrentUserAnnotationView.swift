//
//  CurrentUserAnnotationView.swift
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
class CurrentUserAnnotationView: MGLUserLocationAnnotationView {

    let size: CGFloat = 50
    let imageLayer = CALayer()
  
    override func update() {
        if frame.isNull {
            frame = CGRect(x: 0, y: 0 , width: size, height: size)
            return setNeedsLayout()
        }
        imageLayer.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        let imageView = UIImageView()
        imageView.loadUserImage(url: userAnnotationImage!)
        imageLayer.contents = imageView.image?.cgImage
        imageLayer.cornerRadius = imageLayer.frame.size.width/2
        imageLayer.masksToBounds = true
        imageLayer.borderWidth = 2
        imageLayer.borderColor = UIColor.white.cgColor
        layer.addSublayer(imageLayer)
    }
    
}
