//
//  Structs.swift
//  MapboxMobileEvents
//
//  Created by Nagy istván on 2020. 07. 25..
//

/**
   #Adatmodellek definiálása
*/

import Foundation
import CoreLocation
import Mapbox

struct ProfilResponse: Codable {
    var loginUrl: String?
    let logoutUrl: String?
    let ssoLogoutUrl: String?
    let user: KeyCloakUser?
    let tokenIssueTs: Int?
}

struct DeleteStr: Codable {
    let id: Int
}
struct CoordinateBound: Codable {
    let leftTop: LatLngNyomio
    let rightTop: LatLngNyomio
    let leftBottom: LatLngNyomio
    let rightBottom: LatLngNyomio
}

struct LatLngNyomio: Codable {
    let lat: Double
    let long: Double
}
struct ZoomToLatLngNyomio: Codable {
    var lat: Double
    var long: Double
    var zoom: Double?
}

struct LatLngBoundsNyomio: Codable {
    let center: LatLngNyomio
    let zoom: Double
    let bearing: Double
    let distanceToNorthEast: Double
    let distanceToSouthWest: Double
}
struct KeyCloakUser: Codable {
    let userName: String?
    let email: String?
    let language: String?
  
}

struct Location: Codable {
    var data: String
    var id: Int
    var lat: Double
    var lng: Double
    var timestamp: Int
    
    static func create(fromCLLocation location: CLLocation) -> Location {
        let id = 0
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        let timestamp = Int(location.timestamp.timeIntervalSince1970 * 1000)
        let accuracy = location.horizontalAccuracy
        let accuracyString = String(format: "%.01f", accuracy)
        let dataSting = "accuracy: " + accuracyString
        let location = Location(data: dataSting, id: id, lat: lat, lng: lng, timestamp: timestamp)
        return location
    }
    
    func getJsonString() -> String {
        let encodedData = try! JSONEncoder().encode(self)
        let str = String(data: encodedData, encoding: .utf8)!
        //print(str)
        return str
    }
}

struct FullLocation: Codable {
    //var data: String
    var id: Int
    var lat: Double
    var lng: Double
    var altitude: Double
    var timestamp: Int
    var horizontalAccuracy: Double
    //meter per second, ha negativ akkor invalid
    var speed: Double
    //degrees starting at due north and continue clockwise around the compass
    var course: Double
    
    
    static func create(fromCLLocation location: CLLocation) -> FullLocation {
        let id = 0
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        let alt = location.altitude
        let timestamp = Int(location.timestamp.timeIntervalSince1970 * 1000)
        let accuracy = location.horizontalAccuracy
        let speed = location.speed
        let course = location.course
        //let accuracyString = String(format: "%.01f", accuracy)
        //let dataSting = "accuracy: " + accuracyString
        //let location = Location(data: dataSting, id: id, lat: lat, lng: lng, timestamp: timestamp)
        //return location
        let fullLocation = FullLocation(id: 0, lat: lat, lng: lng, altitude: alt, timestamp: timestamp, horizontalAccuracy: accuracy, speed: speed, course: course)
        return fullLocation
    }
    
    func getJsonString() -> String {
        let encodedData = try! JSONEncoder().encode(self)
        let str = String(data: encodedData, encoding: .utf8)!
        //print(str)
        return str
    }
}

struct FlutterLocation: Codable {
    //var data: String
    var id: Int
    var lat: Double
    var lng: Double
    var alt: Double
    var timestamp: Int
    var accuracy: Int
    //meter per second, ha negativ akkor invalid
    var speed: Double
    //degrees starting at due north and continue clockwise around the compass
    var heading: Double
    var data: String
    
    static func create(fromCLLocation location: CLLocation) -> FlutterLocation {
        let id = 0
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        let alt = location.altitude
        let timestamp = Int(location.timestamp.timeIntervalSince1970 * 1000)
        let accuracy = Int(location.horizontalAccuracy)
        let speed = location.speed
        let course = location.course
        let flutterLocation = FlutterLocation(id: id, lat: lat, lng: lng, alt: alt, timestamp: timestamp, accuracy: accuracy, speed: speed, heading: course, data: "")
        return flutterLocation
    }
    
    func getJsonString() -> String {
        let encodedData = try! JSONEncoder().encode(self)
        let str = String(data: encodedData, encoding: .utf8)!
        //print(str)
        return str
    }
}



struct FullVisit: Codable {
    var id: Int
    var lat: Double
    var lng: Double
    var arrival: Int
    var departure: Int
    var horizontalAccuracy: Double
    
    static func create(fromCLVisit visit: CLVisit) -> FullVisit {
        let id = 0
        let lat = visit.coordinate.latitude
        let lng = visit.coordinate.longitude
        let accuracy = visit.horizontalAccuracy
        let arrival = visit.arrivalDate
        let departure = visit.departureDate
        let arrivalTimestamp = Int(arrival.timeIntervalSince1970 * 1000)
        let departureTimestamp = Int(departure.timeIntervalSince1970 * 1000)
        let fullVisit = FullVisit(id: id, lat: lat, lng: lng, arrival: arrivalTimestamp, departure: departureTimestamp, horizontalAccuracy: accuracy)
        return fullVisit
    }
    
    func getJsonString() -> String {
        let encodedData = try! JSONEncoder().encode(self)
        let str = String(data: encodedData, encoding: .utf8)!
        print(str)
        return str
    }
}


struct Tracker: Codable {
    var id: Int?
    var name: String?
    var latlong: LatLng
    var image: String?
    var color: String? = "#ffffff"
}
struct Place: Codable {
    var id: Int
    var name: String
    var center: LatLng
    var latlongs: [LatLng]
    var color: String? = "#990000ff"
}
struct LatLng: Codable {
    var order: Int
    var lat: Double
    var long: Double
}
