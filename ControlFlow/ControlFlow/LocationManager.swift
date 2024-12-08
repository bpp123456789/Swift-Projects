//
//  LocationManager.swift
//  ControlFlow
//
//  Created by William Petrik on 12/5/24.
//

import Foundation
import MapKit
import SwiftUI

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    // always add info.plist message for privacy when using location data
    
    var location: CLLocation?
    private let locationManager = CLLocationManager()
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var errorMessage: String?
    var locationUpdated: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getRegionAroundCurrentLocation(radiusInMeters: CLLocationDistance = 10000) -> MKCoordinateRegion? {
        guard let location = location else { return nil }
        return MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radiusInMeters, longitudinalMeters: radiusInMeters)
    }
    
    
}

extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        location = newLocation
        locationUpdated?(newLocation)
        //only once
        manager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
        print("🗺️ error LocationManager: \(errorMessage ?? "")")
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("LocationManager authorization granted.")
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("LocationManager authorization denied.")
            errorMessage = "LocationManager authorization denied."
            manager.stopUpdatingLocation()
        case .notDetermined:
            print("LocationManager authorization not determined.")
            manager.requestWhenInUseAuthorization()
        @unknown default:
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}
