//
//  RouteMethods.swift
//  Pods
//
//  Created by Nagy istván on 2020. 09. 04..
//

import Foundation
import Mapbox


/*
 # Route methods ----------------------------------------------------------------------------------------------------------------
 */
extension MapboxMapController {
    
    /*
    # Route hozzáadása
    */
    func addRoute(_ points: [CLLocationCoordinate2D]){
        allCoordinates = points
        addPolyline()
        animatePolyline()
    }
       
    /*
    # Route hozzáadása a térképre
    */
    func addPolyline() {
        let ss = self.mapView.style?.sources.first(where: { (s) -> Bool in
            s.identifier == POLYLINE
        })
        if ss != nil {
            let lay = self.mapView.style?.layers.first(where: { (l) -> Bool in
                l.identifier == POLYLINE
            })
            if lay != nil {
                self.mapView.style?.removeLayer(lay!)
            }
            self.mapView.style?.removeSource(ss!)
        }
           
        let source = MGLShapeSource(identifier: POLYLINE, shape: nil, options: nil)
        self.mapView.style?.addSource(source)
        polylineSource = source
           
        let layer = MGLLineStyleLayer(identifier: POLYLINE, source: source)
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        layer.lineColor = NSExpression(forConstantValue: UIColor.red)
           
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", [14: 5, 18: 20])
        self.mapView.style?.addLayer(layer)
    }
    /*
    # Route animálásának indítása
    */
    func animatePolyline() {
        currentIndex = 1
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    /*
    # Route animálása fél másodpercenként
    */
    @objc func tick(_ sender: Any) {
        if currentIndex > allCoordinates.count {
            currentIndex = 1
            return
        }
        let coordinates = Array(allCoordinates[0..<currentIndex])
        updatePolylineWithCoordinates(coordinates: coordinates)
        currentIndex += 1
    }
    /*
    # Route frissítése a térképen
    */
    func updatePolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        var mutableCoordinates = coordinates
        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
        polylineSource?.shape = polyline
    }
    
}
