//
//  File.swift
//  Pods
//
//  Created by Nagy istván on 2020. 09. 04..
//

import Foundation
import Mapbox

/*
     # Tracker methods ----------------------------------------------------------------------------------------------------------------
*/
extension MapboxMapController {
    
    /*
    # Tracker annotation-ök felvétele a térképre
    */
    func addTrackers(trackers: [Tracker]){
        unitedTrackers = trackers
        DispatchQueue.main.async {
            self.refreshAnnotations()
            
        }
    }
    
    /*
       # Tracker annotation törlése a térképről
    */
    func removeTracker(tracker: Int){
         unitedTrackers.removeAll { (p) -> Bool in
            p.id == tracker
        }
        DispatchQueue.main.async {
            self.refreshAnnotations()
        }
    }
    /*
    # Visszaadja az adott annotation Tracker object-jét, ha létezik
    */
    func findTracker(forAnnotaiton annotation: MGLAnnotation) -> Tracker? {
        return unitedTrackers.first { (tracker) -> Bool in
            return annotation.coordinate == CLLocationCoordinate2D(latitude: tracker.latlong.lat, longitude: tracker.latlong.long) && annotation.title == tracker.name
        }
    }
    /*
    # Visszaadja az adott koordináta Tracker object-jét, ha létezik
    */
    func findTracker(forCoordinate coordinate: CLLocationCoordinate2D) -> Tracker? {
        return unitedTrackers.first { (tracker) -> Bool in
            CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distance(from: CLLocation(latitude: tracker.latlong.lat, longitude: tracker.latlong.long)) < 5
        }
    }
}

