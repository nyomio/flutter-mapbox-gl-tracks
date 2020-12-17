//
//  PlaceMethods.swift
//  Pods
//
//  Created by Nagy istván on 2020. 09. 04..
//

import Foundation
import Mapbox


/*
    # Place methods ----------------------------------------------------------------------------------------------------------------
*/
extension MapboxMapController {
    /*
        # Polygon hozzáadása
    */
    func addPolygon(coordinates: [CLLocationCoordinate2D], name: String, id: Int){
        polygonCircleForCoordinate(coordinates: coordinates, withMeterRadius: 20.0)
    }
        
    /*
    # Kör generálása a polygon középpontjára
    */
    func polygonCircleForCoordinate(coordinates: [CLLocationCoordinate2D], withMeterRadius: Double, title: String = "test") {
        let polygon = MGLPolygon(coordinates: coordinates, count: UInt(coordinates.count))
        polygon.title = title
        self.mapView.addAnnotation(polygon)
    }
        
    /*
    # Place annotation-ök felvétele a térképre
    */
    func addPlaces(places: [Place]){
        locations = places
        DispatchQueue.main.async {
            self.refreshAnnotations()
        }
    }
        
    /*
    # Place annotation törlése a térképről
    */
    func removePlace(place: Int){
        locations.removeAll { (p) -> Bool in
            p.id == place
        }
        DispatchQueue.main.async {
            self.refreshAnnotations()
        }
    }
    /*
     # Visszaadja az adott annotation Place object-jét, ha létezik
     */
    func findLocation(forAnnotaiton annotation: MGLAnnotation) -> Place? {
        return locations.first { (l) -> Bool in
            l.name == annotation.title
        }
    }
    /*
    # Visszaadja az adott koordináta Place object-jét, ha létezik
    */
    func findPlace(forCoordinate coordinate: CLLocationCoordinate2D) -> Place? {
        var pl: Place? = nil
        locations.forEach { (place) in
            if CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distance(from: CLLocation(latitude: place.center.lat, longitude: place.center.long)) < 10 {
                pl = place
            }
            place.latlongs.forEach { (latlng) in
                if CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distance(from: CLLocation(latitude: latlng.lat, longitude: latlng.long)) < 10 {
                    pl = place
                }
            }
        }
        return pl
    }
}
