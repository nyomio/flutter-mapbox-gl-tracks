//
//  StoreImage.swift
//  MapboxMobileEvents
//
//  Created by Nagy istván on 2020. 07. 25..
//

import Foundation
import UIKit
import Mapbox

/**
    #Kép letöltése
 */
func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}

/**
   #Tracker annotation kép letöltése
*/
func downloadImage(vc: UIViewController, name: String, from url: URL, onComplete: @escaping (UIImage?) -> (Void)) -> Void {
    getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        print(response?.suggestedFilename ?? url.lastPathComponent)
        print("Download Finished")
        DispatchQueue.main.async() { [weak vc] in
            store(image: data, forKey: name)
            if let img = retrieveImage(forKey: name) {
                let im = resizeImage(image: img, targetSize: CGSize(width: 150, height: 150))
                onComplete(im)
            }
            
        }
    }
}

/**
   #Tracker annotation kép háttértárból való betöltése, ha sikertelen letöltjük
*/
func getSavedImage(vc: UIViewController, from url: URL, named: String , onComplete: @escaping (UIImage?) -> (Void)) -> Void {
        if let img = retrieveImage(forKey: named) {
            let image = resizeImage(image: img, targetSize: CGSize(width: 150, height: 150))
            onComplete(image)
        } else {
            downloadImage(vc: vc, name: named, from: url, onComplete: onComplete)
        }
   
}

/**
   #Tracker annotation kép átméretezése a Mapnak megfelelő méretre
*/
func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }

    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
        return UIImage()
    }
    UIGraphicsEndImageContext()

    return newImage
}

/**
   #Kép elérése a telefon háttértárából, ha létezik
*/
private func filePath(forKey key: String) -> URL? {
    let fileManager = FileManager.default
    guard let documentURL = fileManager.urls(for: .documentDirectory,
                                            in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
    return documentURL.appendingPathComponent(key + ".png")
}
/**
   #Kép tárolása a telefon háttértárába, ha létezik
*/
private func store(image: Data?,
                    forKey key: String) {
    if let pngRepresentation = image {
      
            if let filePath = filePath(forKey: key) {
                do  {
                    try pngRepresentation.write(to: filePath,
                                                options: .atomic)
                } catch let err {
                    print("Saving file resulted in error: ", err)
                }
            }
       
    }
}
/**
   #Kép háttértárból való betöltése, ha létezik
*/
private func retrieveImage(forKey key: String) -> UIImage? {
  
        if let filePath = filePath(forKey: key),
            let fileData = FileManager.default.contents(atPath: filePath.path),
            let image = UIImage(data: fileData) {
            return image
        }
  
    
    return nil
}
