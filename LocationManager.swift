//
//  LocationManager.swift
//  Curios
//
//  Created by YB on 01/10/19.
//  Copyright © 2019 Youngbrainz. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

enum Result <T> {
    case Success(T)
    case Failure
}
typealias JSONDictionary = [String:Any]

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared: LocationManager = LocationManager()
    
    typealias Callback = (Result <LocationManager>) -> Void
    
    var requests: Array <Callback> = Array <Callback>()
    
    var location: CLLocation? { return sharedLocationManager.location  }
    
    lazy var sharedLocationManager: CLLocationManager = {
        let newLocationmanager = CLLocationManager()
        newLocationmanager.delegate = self
        CLLocationManager().delegate = self
        return newLocationmanager
    } ()
    
    // MARK: - Authorization
    
    class func authorize() { shared.authorize() }
    func authorize() { sharedLocationManager.requestWhenInUseAuthorization() }
    
    // MARK: - Helpers
    func locate(callback: @escaping Callback) {
        self.requests.append(callback)
        sharedLocationManager.startUpdatingLocation()
    }
    
    func reset() {
        self.requests = Array <Callback>()
        sharedLocationManager.stopUpdatingLocation()
    }
    
    // MARK: - Delegate
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        for request in self.requests { request(.Failure) }
        self.reset()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: Array <CLLocation>) {
        for request in self.requests { request(.Success(self)) }
        self.reset()
    }
    
    func getAdress(currentLocation: CLLocation, completion: @escaping (_ address: JSONDictionary?, _ error: Error?) -> ()) {
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            
            if let e = error {
                completion(nil, e)
            } else {
                let placeArray = placemarks
                
                var placeMark: CLPlacemark!
                
                placeMark = placeArray?[0]
                
                guard let address = placeMark.addressDictionary as? JSONDictionary else {
                    return
                }
                completion(address, nil)
            }
        }
    }
}
