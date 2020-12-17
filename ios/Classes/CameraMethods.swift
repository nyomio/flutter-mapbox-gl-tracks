//
//  CameraMethods.swift
//  Pods
//
//  Created by Nagy istván on 2020. 09. 04..
//

import Foundation
import Mapbox

extension MapboxMapController {
    func setPosition(forTracker tracker: Tracker, withZoomLevel zoomLevel: Double = 16) {
        mapView.setCenter(CLLocationCoordinate2D(latitude: tracker.latlong.lat, longitude: tracker.latlong.long), animated: false)
        mapView.setZoomLevel(zoomLevel, animated: false)
    }
    
    func showAllAnnotations(withMyTrackers trackers: [Tracker]){
        mapView.setVisibleCoordinateBounds(generateCoordinatesBounds(withMyTrackers: trackers), animated: true)
    }
      
    func generateCoordinatesBounds(withMyTrackers trackers: [Tracker]) -> MGLCoordinateBounds {
        var maxN = CLLocationDegrees(), maxS = CLLocationDegrees() , maxE = CLLocationDegrees() , maxW = CLLocationDegrees()
        for coordinates in trackers {
            if Double(coordinates.latlong.lat) >= maxN || maxN == 0 { maxN = coordinates.latlong.lat }
            if Double(coordinates.latlong.lat) <= maxS || maxS == 0 { maxS = coordinates.latlong.lat }
            if Double(coordinates.latlong.long) >= maxE || maxE == 0 { maxE = coordinates.latlong.long }
            if Double(coordinates.latlong.long) <= maxW || maxW == 0{ maxW = coordinates.latlong.long }
        }
        let offset = 0.01
        let maxNE = CLLocationCoordinate2D(latitude: maxN + offset, longitude: maxE + offset)
        let maxSW =  CLLocationCoordinate2D(latitude: maxS - offset, longitude: maxW - offset)
        return MGLCoordinateBounds(sw: maxSW, ne: maxNE)
    }
    
    
    func getCurrentLocation(){
//        self.locationManager.requestAlwaysAuthorization()
//        self.locationManager.requestWhenInUseAuthorization()
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//            let camera = MGLMapCamera()
//            camera.centerCoordinate.latitude = locationManager.location?.coordinate.latitude ?? 47.5
//            camera.centerCoordinate.longitude = locationManager.location?.coordinate.longitude ?? 19.5
//            mapView?.setCamera(camera, animated: false)
//            mapView?.setCenter(CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 47.5, longitude: locationManager.location?.coordinate.longitude ?? 19.5), zoomLevel: 16, animated: false)
//        }
    }
}
