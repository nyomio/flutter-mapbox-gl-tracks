//
//  TrackerAnnotationView.swift
//  MapboxMobileEvents
//
//  Created by Nagy istván on 2020. 07. 25..
//

import UIKit
import Mapbox

/**
     #A trackerek saját annoation osztálya, hogy meg tudjuk jeleníteni az egyedi lekérdezett képeket
*/

class TrackerAnnotationView2: MGLAnnotationView {
    
    let size: CGFloat = 32
    let imageLayer = CALayer()
    
    init(annotation: MGLAnnotation?, reuseIdentifier: String?, tracker: Tracker) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: size, height: size)
        imageLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)
        let imageView = UIImageView()
        imageView.loadImage(url: tracker.image ?? "")
        imageLayer.contents = imageView.image?.cgImage
        imageLayer.cornerRadius = imageLayer.frame.size.width/2
        imageLayer.masksToBounds = true
        imageLayer.borderWidth = 2.0
        imageLayer.borderColor = tracker.color?.getColor()?.cgColor
        layer.addSublayer(imageLayer)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}
