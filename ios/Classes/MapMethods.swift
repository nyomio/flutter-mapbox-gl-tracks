//
//  MapMethods.swift
//  Pods
//
//  Created by Nagy istván on 2020. 09. 04..
//

import Foundation
import Mapbox

/*
     # Map methods ----------------------------------------------------------------------------------------------------------------
*/
    
extension MapboxMapController {
   
    
    func setCompassVisible(_ visible: Bool){
//        isCompassVisible = visible
        mapView.compassView.isHidden = visible
    }
    
    func setMapStyle(style: String){
        switch style {
            case "ourdoor":
                mapView.styleURL = MGLStyle.outdoorsStyleURL
            case "street":
                mapView.styleURL = MGLStyle.streetsStyleURL
            case "dark":
                mapView.styleURL = MGLStyle.darkStyleURL
            case "light":
                mapView.styleURL = MGLStyle.lightStyleURL
            case "satellite":
                mapView.styleURL = MGLStyle.satelliteStyleURL
            default:
               print("setMapStyle fail", style)
        }
    }
}
