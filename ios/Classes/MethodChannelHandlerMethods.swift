//
//  MethodChannelHandlerExtension.swift
//  Pods
//
//  Created by Nagy istván on 2020. 09. 04..
//

import Foundation
import Mapbox
import UIKit

//MARK:FLUTTER METHODS ------------------------------------------------------


var userAnnotationImage: String? = nil
var userAnnotationImageDidChange = false

extension MapboxMapController {
    
    func setupNotifications(){
        
        //MARK:setUserLocationVisible METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.setUserLocationVisibleNotification(notification:)),
                                               name: Notification.Name("setUserLocationVisible"),
                                               object: nil)
        //MARK:setUserImage METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.setUserAnnotationImageNotification(notification:)),
                                               name: Notification.Name("setUserImage"),
                                               object: nil)
        //MARK:setCompassVisible METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.setCompassVisibleNotification(notification:)),
                                               name: Notification.Name("setCompassVisible"),
                                               object: nil)
        //MARK:setMapStyle METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.setMapStyleNotification(notification:)),
                                               name: Notification.Name("setMapStyle"),
                                               object: nil)
       
        //MARK:addPlaces METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.addPlacesNotification(notification:)),
                                               name: Notification.Name("addPlaces"),
                                               object: nil)
        //MARK:addPlace METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.addPlaceNotification(notification:)),
                                               name: Notification.Name("addPlace"),
                                               object: nil)
        //MARK:addTracker METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.addTrackerNotification(notification:)),
                                               name: Notification.Name("addTracker"),
                                               object: nil)
        //MARK:updateTracker METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateTrackerNotification(notification:)),
                                               name: Notification.Name("updateTracker"),
                                               object: nil)
        //MARK:addTrackers METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.addTrackersNotification(notification:)),
                                               name: Notification.Name("addTrackers"),
                                               object: nil)
        //MARK:deleteTracker METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.deleteTrackerNotification(notification:)),
                                               name: Notification.Name("deleteTracker"),
                                               object: nil)
        //MARK:deletePlace METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.deletePlaceNotification(notification:)),
                                               name: Notification.Name("deletePlace"),
                                               object: nil)
        //MARK:zoomToCoordinateBound METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.zoomToCoordinateBoundNotification(notification:)),
                                               name: Notification.Name("zoomToCoordinateBound"),
                                               object: nil)
        //MARK:getCoordinateBounds METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.getCoordinateBoundsNotification(notification:)),
                                               name: Notification.Name("getCoordinateBounds"),
                                               object: nil)
        //MARK:addErrors METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.addErrorsNotification(notification:)),
                                               name: Notification.Name("addErrors"),
                                               object: nil)
        //MARK:addPolygons METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.addPolygonsNotification(notification:)),
                                               name: Notification.Name("addPolygons"),
                                               object: nil)
        //MARK:addCircle METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.addCircleNotification(notification:)),
                                               name: Notification.Name("addCircle"),
                                               object: nil)
        //MARK:showCurrentPosition METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.showCurrentPositionNotification(notification:)),
                                               name: Notification.Name("showCurrentPosition"),
                                               object: nil)
        //MARK:drawRoute METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.drawRouteNotification(notification:)),
                                               name: Notification.Name("drawRoute"),
                                               object: nil)
        //MARK:getScreenCornersLocations METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.getScreenCornersLocationsNotification(notification:)),
                                               name: Notification.Name("getScreenCornersLocations"),
                                               object: nil)
                  
        //MARK:refreshAnnotations METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshAnnotationsNotification(notification:)),
                                               name: Notification.Name("refreshAnnotations"),
                                               object: nil)
                    
        //MARK:zoomToCoordinate METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.zoomToCoordinateNotification(notification:)),
                                               name: Notification.Name("zoomToCoordinate"),
                                               object: nil)
        //MARK:getCoordinateAndZoom METHOD 1 ------------------------------------------------------
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.getCoordinateAndZoomNotification(notification:)),
                                               name: Notification.Name("getCoordinateAndZoom"),
                                               object: nil)
        
    }
    
    //MARK:refreshAnnotations METHOD 2 ------------------------------------------------------
    @objc func refreshAnnotationsNotification(notification: Notification) {
        self.refreshAnnotations()
    }
    
    //MARK:getCoordinateAndZoom METHOD 2 ------------------------------------------------------
    @objc func getCoordinateAndZoomNotification(notification: Notification) {
        let lat =  self.mapView.camera.centerCoordinate.latitude
        let long = self.mapView.camera.centerCoordinate.longitude
        let zoom = (self.mapView.zoomLevel ?? 0.0) + 0.001
        let coordinateBounds = ZoomToLatLngNyomio(lat: lat, long: long, zoom: zoom)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(coordinateBounds)
        if jsonData != nil {
            print(String(data: jsonData!, encoding: .utf8))
            let jsonString = String(data: jsonData!, encoding: .utf8)
            fresult!(jsonString)
        }
    }
    //MARK:drawRoute METHOD 2 ------------------------------------------------------
    @objc func drawRouteNotification(notification: Notification) {
        do {
            let data: String = notification.userInfo!["data"] as! String
            let parsedData = try? JSONDecoder().decode([LatLng].self, from: data.data(using: .utf8)!)
            print(parsedData)
            if parsedData != nil && parsedData!.count > 0{
                var coords: [CLLocationCoordinate2D] = []
                let sorted = parsedData!.sorted(by: { (l1, l2) -> Bool in
                    l1.order < l2.order
                })
                sorted.forEach { (ll) in
                    coords.append(CLLocationCoordinate2D(latitude: ll.lat, longitude: ll.long))
                }
                DispatchQueue.main.async {
                    self.addRoute(coords)
                }
            }
            else {
                print("route decoding error")
            }
        }
        catch {
            print("route decoding error")
        }
    }
    //MARK:getScreenCornersLocations METHOD 2 ------------------------------------------------------
    @objc func getScreenCornersLocationsNotification(notification: Notification) {
        print(notification.userInfo)
    }
    //MARK:setMapStyle METHOD 2 ------------------------------------------------------
    @objc func setMapStyleNotification(notification: Notification) {
        self.setMapStyle(style: notification.userInfo!["data"] as! String)
    }
               
    //MARK:setCompassVisible METHOD 2 ------------------------------------------------------
    @objc func setCompassVisibleNotification(notification: Notification) {
        do {
            let data: Bool? = notification.userInfo!["data"] as! Bool
            if data != nil {
                self.setCompassVisible(data!)
            }
            else {
                print("setCompassVisible decoding error")
            }
        }
        catch {
            print("setCompassVisible decoding error")
        }
    }
    //MARK:setUserLocationVisible METHOD 2 ------------------------------------------------------
    @objc func setUserLocationVisibleNotification(notification: Notification) {
        let data: Bool = notification.userInfo!["data"] as! Bool
        self.mapView.showsUserLocation = data
    }
    
    //MARK:addTrackers METHOD 2 ------------------------------------------------------
    @objc func addTrackersNotification(notification: Notification) {
        do {
            let data: String = notification.userInfo!["data"] as! String
            let parsedData = try? JSONDecoder().decode([Tracker].self, from: data.data(using: .utf8)!)
            if parsedData != nil {
                self.addTrackers(trackers: parsedData!)
            }
            else {
                print("trackers decoding error")
            }
        }
        catch {
            print("trackers decoding error")
        }
    }
    
    //MARK:addPlaces METHOD 2 ------------------------------------------------------
    @objc func addPlacesNotification(notification: Notification) {
        do {
            let data: String = notification.userInfo!["data"] as! String
            let parsedData = try? JSONDecoder().decode([Place].self, from: data.data(using: .utf8)!)
            if parsedData != nil {
                self.addPlaces(places: parsedData!)
            }
            else {
                print("places decoding error")
            }
        }
        catch {
            print("places decoding error")
        }
    }
    //MARK:addTracker METHOD 2 ------------------------------------------------------
    @objc func addTrackerNotification(notification: Notification) {
        do {
            let data: String = notification.userInfo!["data"] as! String
            let parsedData = try? JSONDecoder().decode([Tracker].self, from: data.data(using: .utf8)!)
            if parsedData != nil && parsedData!.count > 0{
                unitedTrackers.append((parsedData?.first)!)
                addTrackers(trackers: unitedTrackers)
            }
            else {
                print("trackers decoding error")
            }
        }
        catch {
            print("trackers decoding error")
        }
    }
    //MARK:addPlace METHOD 2 ------------------------------------------------------
    @objc func addPlaceNotification(notification: Notification) {
        do {
            let data: String = notification.userInfo!["data"] as! String
            let parsedData = try? JSONDecoder().decode([Place].self, from: data.data(using: .utf8)!)
            if parsedData != nil && parsedData!.count > 0{
                locations.append((parsedData?.first)!)
                addPlaces(places: locations)
            }
            else {
                print("places decoding error")
            }
        }
        catch {
            print("places decoding error")
        }
    }
        
    //MARK:deleteTracker METHOD 2 ------------------------------------------------------
    @objc func deleteTrackerNotification(notification: Notification) {
        do {
            let data: String = notification.userInfo!["data"] as! String
            let parsedData = try? JSONDecoder().decode([DeleteStr].self, from: data.data(using: .utf8)!)
            if parsedData != nil && parsedData!.count > 0{
                self.removeTracker(tracker: parsedData!.first!.id)
            }
            else {
                print("trackers decoding error")
            }
        }
        catch {
            print("trackers decoding error")
        }
    }
    
    @objc func  deletePlaceNotification(notification: Notification) {
        do {
            let data: String = notification.userInfo!["data"] as! String
            let parsedData = try? JSONDecoder().decode([DeleteStr].self, from: data.data(using: .utf8)!)
            if parsedData != nil && parsedData!.count > 0{
                self.removePlace(place: parsedData!.first!.id)
            }
            else {
                print("places decoding error")
            }
        }
        catch {
            print("places decoding error")
        }
    }
    @objc func updateTrackerNotification(notification: Notification) {
//        do {
//            let data: String = notification.userInfo!["data"] as! String
//            let parsedData = try? JSONDecoder().decode([Tracker].self, from: data.data(using: .utf8)!)
//            if parsedData != nil && parsedData!.count > 0 && self.unitedTrackers.count > 0{
//                for i in 0...self.unitedTrackers.count-1 {
//                    if self.unitedTrackers[i].id == parsedData?.first?.id {
//                        self.unitedTrackers[i] = (parsedData?.first)!
//                    }
//                }
//                DispatchQueue.main.async {
//                    self.refreshAnnotations()
//                }
//            }
//            else {
//                print("trackers decoding error")
//            }
//        }
//        catch {
//            print("trackers decoding error")
//        }
    }
    @objc func addErrorsNotification(notification: Notification) {
        print(notification.userInfo)
    }
    
    @objc func zoomToCoordinateBoundNotification(notification: Notification) {
        do {
            let data: String = notification.userInfo!["data"] as! String
            let parsedData = try? JSONDecoder().decode([CoordinateBound].self, from: data.data(using: .utf8)!)
            if parsedData != nil && parsedData!.count > 0{
                DispatchQueue.main.async {
                    self.mapView.setVisibleCoordinateBounds(MGLCoordinateBounds(sw: CLLocationCoordinate2D(latitude: parsedData!.first!.leftTop.lat, longitude: parsedData!.first!.leftTop.long), ne: CLLocationCoordinate2D(latitude: parsedData!.first!.rightBottom.lat, longitude: parsedData!.first!.rightBottom.long)), animated: true)
                }
            }
            else {
                print("places decoding error")
            }
        }
        catch {
            print("places decoding error")
        }
    }
        
    @objc func getCoordinateBoundsNotification(notification: Notification) {
        let bounds = self.mapView.visibleCoordinateBounds
        let center = LatLngNyomio(lat: (self.mapView.centerCoordinate.latitude) ?? 0.0, long: self.mapView.centerCoordinate.longitude ?? 0.0)
        let zoom: Double = ((self.mapView.zoomLevel) ?? 15.0) + 0.001
        let bearing: Double = 0.4
        let distanceToNorthEast = CLLocation.distance(from: self.mapView.centerCoordinate, to: bounds.ne)
        let distanceToSouthWest = CLLocation.distance(from: self.mapView.centerCoordinate, to: bounds.sw)
        let coordinateBounds = LatLngBoundsNyomio(center: center, zoom: zoom, bearing: bearing, distanceToNorthEast: distanceToNorthEast, distanceToSouthWest: distanceToSouthWest)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(coordinateBounds)
        if jsonData != nil {
            let jsonString = String(data: jsonData!, encoding: .utf8)
            fresult!(jsonString)
        }
    }
    
    @objc func addPolygonsNotification(notification: Notification) {
        print(notification.userInfo)
    }
    
    @objc func addCircleNotification(notification: Notification) {
        print(notification.userInfo)
    }
    
    @objc func showCurrentPositionNotification(notification: Notification) {
        getCurrentLocation()
    }
    @objc func zoomToCoordinateNotification(notification: Notification) {
        do {
            let data: String = notification.userInfo!["data"] as! String
            let parsedData = try? JSONDecoder().decode([ZoomToLatLngNyomio].self, from: data.data(using: .utf8)!)
            if parsedData != nil && parsedData!.count > 0{
                DispatchQueue.main.async {
                    self.mapView.setCamera(MGLMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: parsedData!.first!.lat, longitude: parsedData!.first!.long), altitude: (self.mapView.camera.altitude), pitch: (self.mapView.camera.pitch), heading: (self.mapView.camera.heading)), animated: true)
                    if parsedData!.first!.zoom != nil {
                        self.mapView.setZoomLevel(parsedData!.first!.zoom!, animated: true)
                    }
                }
            }
            else {
                print("places decoding error")
            }
        }
        catch {
            print("places decoding error")
        }
    }
    
    @objc func setUserAnnotationImageNotification(notification: Notification) {
        do {
            let data: String = notification.userInfo!["data"] as! String
            userAnnotationImageDidChange = true
            userAnnotationImage = data
            DispatchQueue.main.async {
                self.mapView.showsUserLocation = false
                self.mapView.showsUserLocation = true
                self.mapView.updateUserLocationAnnotationView()
            }
        }
        catch {
            print("places decoding error")
        }
    }
}
