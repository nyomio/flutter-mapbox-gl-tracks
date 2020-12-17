//
//  ClickMethods.swift
//  Pods
//
//  Created by Nagy istván on 2020. 09. 04..
//

import Foundation
import Mapbox

extension MapboxMapController {
    
    func addLongpressGestureRecognizer(){
        let longPressGS = UILongPressGestureRecognizer(target: self, action: #selector(logpressAction(_:)))
        mapView.addGestureRecognizer(longPressGS)
    }
    
    func addPressGestureRecognizer(){
        let pressGS = UITapGestureRecognizer(target: self, action: #selector(pressAction(_:)))
        if mapView != nil && mapView.gestureRecognizers != nil {
            for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
                pressGS.require(toFail: recognizer)
            }
        }
        mapView.addGestureRecognizer(pressGS)
    }
    
    @objc func logpressAction(_ sender: UILongPressGestureRecognizer){
        var point = mapView.anchorPoint(forGesture: sender)
        
        if sender.state == .began {
            point = sender.location(in: mapView)
            print("megvan a longpress: ", point.debugDescription)
            let coordinate = mapView.convert(point, toCoordinateFrom: nil)
            if coordinate != nil {
            if let tracker = findTracker(forCoordinate: coordinate) {
                print("meg lett HosszúKattin(ka)tva a tracker")
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: ["id":tracker.id], options: .prettyPrinted)
                    // here "jsonData" is the dictionary encoded in JSON data
                    let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    // here "decoded" is of type `Any`, decoded from JSON data
                    // you can now cast it with the right type
                    channel?.invokeMethod("map_marker_longclick", arguments: decoded)
                    print(decoded)
                } catch {
                    print(error.localizedDescription)
                }
            }
            else if let place = findPlace(forCoordinate: coordinate) {
                print("meg lett HosszúKattin(ka)tva a tracker")
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: ["id":place.id], options: .prettyPrinted)
                    // here "jsonData" is the dictionary encoded in JSON data
                    let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    // here "decoded" is of type `Any`, decoded from JSON data
                    // you can now cast it with the right type
                    channel?.invokeMethod("map_polygon_longclick", arguments: decoded)
                    print(decoded)
                } catch {
                    print(error.localizedDescription)
                }
            }
            else {
                print("meg lett HosszúKattin(ka)tva a térkép")

                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: ["latitude":coordinate.latitude,"longitude":coordinate.longitude], options: .prettyPrinted)
                    // here "jsonData" is the dictionary encoded in JSON data

                    let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    // here "decoded" is of type `Any`, decoded from JSON data
                    // you can now cast it with the right type
                    channel?.invokeMethod("map_longclick", arguments: decoded)
                    print(decoded)
                              
                } catch {
                    print(error.localizedDescription)
                }
            }
            print("Coordinate: lat: ", coordinate.latitude, "lon: ", coordinate.longitude)
            }
        }
    }
    
    @objc @IBAction func pressAction(_ sender: UITapGestureRecognizer){
        //ez nem jo
        var point = mapView.anchorPoint(forGesture: sender)
        print("meg lett kattintva a térkép")
        point = sender.location(in: mapView)
        print("megvan a press: ", point.debugDescription)
        let coordinate = mapView.convert(point, toCoordinateFrom: nil)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: ["latitude":coordinate.latitude,"longitude":coordinate.longitude], options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            // you can now cast it with the right type
            channel?.invokeMethod("map_singleclick", arguments: decoded)
            print(decoded)
        } catch {
            print(error.localizedDescription)
        }
    }

}
