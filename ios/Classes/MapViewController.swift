//
//  MapView.swift
//  MapboxMobileEvents
//
//  Created by Nagy istván on 2020. 07. 18..
//

import UIKit
import Mapbox

/**
 NYOMIO--------------
 */
    var unitedTrackers: [Tracker] = []
    var locations: [Place] = []
    let locationManager = CLLocationManager()
    var isCompassVisible = true
    var showsUserLocation = true
    var timer: Timer?
    var polylineSource: MGLShapeSource?
    var currentIndex = 1
    var allCoordinates: [CLLocationCoordinate2D]!

/**
 NYOMIO ----------------
 */
//
//var userAnnotationImage: String? = nil
//var userAnnotationImageDidChange = false
//class MapViewController: NSObject, FlutterPlatformView, MGLMapViewDelegate, CLLocationManagerDelegate {
//    let frame: CGRect
//    let viewId: Int64
//    init(_ frame: CGRect, viewId: Int64, args: Any?) {
//        self.frame = frame
//        self.viewId = viewId
//        mapView = MGLMapView(frame: frame, styleURL: MGLStyle.darkStyleURL)
//        mapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        super.init()
//        mapView?.delegate = self
//        addLongpressGestureRecognizer()
//        addPressGestureRecognizer()
//        setMap()
//        setupNotifications()
//        channel.invokeMethod("map_init", arguments: "finished")
//    }
//    /*
//    # Térkép inicializálása
//    */
//    func setMap(){
//        if mapView != nil {
//            var centerPoint = mapView!.compassView.center
//            centerPoint.y = self.mapView!.frame.height - 100
//            centerPoint.x = 50
//            mapView!.compassView.center = centerPoint
//            mapView?.logoView.isHidden = true
//               //refreshAnnotations(withMyTackers: unitedTrackers, withMyLocations: locations)
//            mapView?.setCenter(CLLocationCoordinate2D(latitude: 47.31, longitude: 19.06), zoomLevel: 9, animated: false)
//            mapView?.compassView.isHidden = !isCompassVisible
//            getCurrentLocation()
//            mapView?.showsUserLocation = showsUserLocation
//        }
//    }
//
//    public func view() -> UIView {
//        return mapView!
//    }
//
//    var unitedTrackers: [Tracker] = []
//    var locations: [Place] = []
//    let locationManager = CLLocationManager()
//    var mapView: MGLMapView? = nil
//    var isCompassVisible = true
//    var showsUserLocation = true
//    var timer: Timer?
//    var polylineSource: MGLShapeSource?
//    var currentIndex = 1
//    var allCoordinates: [CLLocationCoordinate2D]!
//
//
//
//    @objc func swipeOnMap(_ sender: UISwipeGestureRecognizer){
//        if sender.state == .began {
//            print("swipe began")
//        }
//
//        if sender.state == .ended {
//            print("swipe ended")
//        }
//    }
//
//    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
//        return false
//    }
//
//
//    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
//        print("Tapped the callout for: \(annotation)")
//        mapView.deselectAnnotation(annotation, animated: true)
//    }
//    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
//        if let locations = findLocation(forAnnotaiton: annotation) {
//            return locations.color?.getColor()?.withAlphaComponent(0.5) ?? UIColor.green.withAlphaComponent(0.5)
//        }
//        else {
//            return UIColor.green.withAlphaComponent(0.5)
//        }
//    }
//
//    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
//        print("didSelect")
//        let coordinate = annotation.coordinate
//            mapView.setCenter(coordinate, animated: true)
//        if annotation is MGLPolygon {
//            print("EZ EGY KIBASHZOTT POLYGON")
//            if let locations = findLocation(forAnnotaiton: annotation) {
//                       do {
//                           let jsonData = try JSONSerialization.data(withJSONObject: ["id":locations.id], options: .prettyPrinted)
//                           // here "jsonData" is the dictionary encoded in JSON data
//
//                           let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
//                           // here "decoded" is of type `Any`, decoded from JSON data
//                           // you can now cast it with the right type
//
//                            channel.invokeMethod("map_polygon_click", arguments: decoded)
//                            print(decoded)
//
//                       } catch {
//                           print(error.localizedDescription)
//                       }
//
//                   }
//            else {
//                print("NO LOCATION FOUND",annotation.title)
//            }
//        }
//        else if let tracker = findTracker(forAnnotaiton: annotation) {
//            print("meg lett kattintva a tracker")
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: ["id":tracker.id], options: .prettyPrinted)
//                // here "jsonData" is the dictionary encoded in JSON data
//
//                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
//                // here "decoded" is of type `Any`, decoded from JSON data
//
//                // you can now cast it with the right type
//                channel.invokeMethod("map_marker_singleclick", arguments: decoded)
//                      print(decoded)
//            } catch {
//                print(error.localizedDescription)
//            }
//        } else {
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: ["latitude":annotation.coordinate.latitude,"longitude":annotation.coordinate.longitude], options: .prettyPrinted)
//                         // here "jsonData" is the dictionary encoded in JSON data
//
//                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
//                         // here "decoded" is of type `Any`, decoded from JSON data
//                         // you can now cast it with the right type
//                channel.invokeMethod("map_singleclick", arguments: decoded)
//                print(decoded)
//
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//
//    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
//        if userAnnotationImage != nil && userAnnotationImageDidChange == true {
//            let userAnnotation = mapView.annotations?.first(where: { (ann) -> Bool in
//                ann is MGLUserLocation
//            })
//            if userAnnotation != nil {
//                userAnnotationImageDidChange = false
//                mapView.removeAnnotation(userAnnotation!)
//                mapView.addAnnotation(userAnnotation!)
//            }
//        }
//    }
//
//    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
//        if annotation is MGLUserLocation && mapView.userLocation != nil && userAnnotationImage != nil{
//            return CurrentUserAnnotationView()
//        }
//        else{
//            guard let pin = annotation as? UserLocationAnnotation else { return nil }
//            let tracker = self.unitedTrackers.first { (t) -> Bool in
//                t.name == annotation.title
//            }
//            if tracker != nil {
//                let reuseIdentifier = "TrackerAnnotation"
//                let tracker = self.unitedTrackers.first { (t) -> Bool in
//                    t.name == annotation.title
//                }
//                return TrackerAnnotationView2(annotation: pin, reuseIdentifier: reuseIdentifier, tracker: tracker!)
//            } else {
//                return nil
//            }
//        }
//        let castAnnotation = annotation as? UserLocationAnnotation
//
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: castAnnotation!.identifier)
//
//        if annotationView == nil {
//            if castAnnotation?.identifier.contains("_tracker") ?? false {
//                annotationView = TrackerAnnotationView(reuseIdentifier: castAnnotation!.identifier)
//                annotationView!.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
//                annotationView!.layer.cornerRadius = (annotationView?.frame.size.width)! / 2
//                annotationView!.layer.borderWidth = 4.0
//                //itt fogunk majd a groupokhoz színt állítani
//                annotationView!.layer.borderColor = castAnnotation?.color?.getColor()?.cgColor ?? UIColor.white.cgColor
//
//                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
//                imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2
//                imageView.layer.masksToBounds = true
//                imageView.image = castAnnotation?.uiimage
//                annotationView!.addSubview(imageView)
//            }
//            else if castAnnotation?.identifier.contains("_place") ?? false {
//                annotationView = MyPlaceAnnotation(reuseIdentifier: castAnnotation!.identifier)
//                annotationView!.frame = CGRect(x: 0, y: 0, width: castAnnotation!.size, height: castAnnotation!.size)
//                annotationView!.layer.cornerRadius = (annotationView?.frame.size.width)! / 2
//                annotationView!.backgroundColor = castAnnotation?.color?.getColor() ?? UIColor.white
//                annotationView!.alpha = CGFloat(0.6)
//            }
//        }
//        return annotationView
//    }
//
//    let coordinates = [
//       (19.056889, 47.486706),
//       (19.057661, 47.487089),
//       (19.059402, 47.488119),
//       (19.059890, 47.488214),
//       (19.060649, 47.488679),
//       (19.061529,47.489636),
//       (19.061819, 47.490491),
//       (19.061519, 47.491535),
//       (19.061122,47.492391),
//       (19.060682,47.493188),
//       (19.060049,47.494420),
//       (19.059344, 47.495311),
//       ( 19.058818,47.496116),
//       ( 19.057638,47.496565)
//       ].map({CLLocationCoordinate2D(latitude: $0.1, longitude: $0.0)})
//
//
//
//
//
//    /*
//     # Teszt - már nem használjuk
//     */
//    private func getPlacesAndTrackersFromGithub(){
////        getPlaces { (group) -> (Void) in
////            group.forEach { (t) in
////                t.members?.forEach({ (member) in
////                    self.locations.append(member)
////                    self.locations[self.locations.count-1].groupColor = t.color
////                    self.locations[self.locations.count-1].group = t.name
////                })
////            }
////            DispatchQueue.main.async {
////                self.addAnnotations(forMyTrackers: self.unitedTrackers, forMyLocations: [])
////                getTrackers(onComplete: { trackers in
////                    trackers.trackers.forEach { (t) in
////                        t.members?.forEach({ (member) in
////                            self.unitedTrackers.append(member)
////                            self.unitedTrackers[self.unitedTrackers.count-1].groupColor = t.color
////                            self.unitedTrackers[self.unitedTrackers.count-1].group = t.name
////                        })
////                    }
////                    trackers.shared.forEach { (t) in
////                        t.members?.forEach({ (member) in
////                            self.unitedTrackers.append(member)
////                            self.unitedTrackers[self.unitedTrackers.count-1].groupColor = t.color
////                            self.unitedTrackers[self.unitedTrackers.count-1].group = t.name
////                        })
////                    }
////                    DispatchQueue.main.async {
////                        self.addAnnotations(forMyTrackers: self.unitedTrackers, forMyLocations: self.locations)
////                        self.mapView?.showAnnotations((self.mapView?.annotations)!, animated: true) //this fixed it
////                        self.refreshAnnotations()
////
////                    }
////                })
////            }
////        }
//    }
//
//}

extension MapboxMapController {
    
    @objc func refreshAnnotations(_ notification: Notification){
        refreshAnnotations()
    }
    
        func refreshAnnotations(){
            refreshAnnotations(withMyTackers: unitedTrackers, withMyLocations: locations)
        }
    
        func refreshAnnotations(withMyTackers trackers: [Tracker], withMyLocations locations: [Place]){
            removeAllAnnotation()
            addAnnotations(forMyTrackers: trackers, forMyLocations: locations)
            if self.mapView.annotations != nil {
                self.mapView.showAnnotations((self.mapView.annotations)!, animated: true) //this fixed it
            }
        }
    
        func addAnnotations(forMyTrackers trackers: [Tracker], forMyLocations locations: [Place]){
            for location in locations {
                var coordinates: [CLLocationCoordinate2D] = []
                location.latlongs.sorted { (l1, l2) -> Bool in l1.order < l2.order }.forEach { (latlng) in
                    coordinates.append(CLLocationCoordinate2D(latitude: latlng.lat, longitude: latlng.long))
                }
    
                if let annotation = createPlaceAnnotation(fromPlace: location) {
                polygonCircleForCoordinate(coordinates: coordinates, withMeterRadius: 30.0, title: location.name)
                }
            }
    
            for tracker in trackers {
                if let annotation = createAnnotation(fromTracker: tracker) {
                    mapView.addAnnotation(annotation)
                }
            }
    
        }
    
        func addAnnotationsAndFocusCenter(withMyTrackers trackers: [Tracker], withMyLocations locations: [Place]) {
            removeAllAnnotation()
            addAnnotations(forMyTrackers: trackers, forMyLocations: locations)
            showAllAnnotations(withMyTrackers: trackers)
        }
    
        func removeAllAnnotation(){
            mapView.annotations?.forEach({ (annotation) in
                mapView.removeAnnotation(annotation)
            })
        }
    
        private func createAnnotation(fromTracker tracker: Tracker) -> UserLocationAnnotation? {
    
            let annotation = UserLocationAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: tracker.latlong.lat, longitude: tracker.latlong.long)
            annotation.title = tracker.name
            annotation.subtitle = ""
            annotation.identifier = tracker.name! + "_tracker"
            annotation.image = tracker.image!
            annotation.color = tracker.color
            annotation.group = ""
            return annotation
        }
    
        private func createPlaceAnnotation(fromPlace place: Place) -> UserLocationAnnotation? {
            let annotation = UserLocationAnnotation()
            annotation.title = place.name
            annotation.identifier = place.name + "_place"
            annotation.color = place.color
            if place.id % 2 == 0 {
                annotation.size = 30
            } else {
                annotation.size = 60
            }
            return annotation
    //        return nil
        }
}


