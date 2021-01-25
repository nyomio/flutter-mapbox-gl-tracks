//
//  CustomImageAnnotationView.swift
//  MapboxMobileEvents
//
//  Created by Nagy istván on 2020. 07. 25..
//

import Foundation
import UIKit
import Mapbox

/*
 # Már nem használjuk -> helyette -> TrackerAnnotationView
 #A trackerek saját annoation osztálya, hogy meg tudjuk jeleníteni az egyedi lekérdezett képeket
 */
class CustomImageAnnotationView: MGLAnnotationView {
    var imageView: UIImageView!

    required init(reuseIdentifier: String?, image: Data, name: String, vc: UIViewController) {
        super.init(reuseIdentifier: reuseIdentifier)
      
                let imf = UIImage(data: image)
                self.imageView = UIImageView(image: imf)
                if #available(iOS 13.0, *) {
                    self.imageView.layer.backgroundColor = CGColor(srgbRed: CGFloat(255), green: CGFloat(255), blue: CGFloat(255), alpha: CGFloat(0))
                } else {
                  
                }
                self.imageView.layer.cornerRadius = imf!.size.height / CGFloat(2)
                self.imageView.layer.borderWidth = 5.0;
                self.imageView.layer.masksToBounds = true
                if #available(iOS 13.0, *) {
                    self.imageView.layer.borderColor = CGColor(srgbRed: CGFloat(255), green: CGFloat(255), blue: CGFloat(255), alpha: CGFloat(255))
                } else {
                }
                self.imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                self.addSubview(self.imageView)
                self.frame = self.imageView.frame

        
        
       
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
