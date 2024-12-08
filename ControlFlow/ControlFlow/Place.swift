//
//  Place.swift
//  ControlFlow
//
//  Created by William Petrik on 12/5/24.
//

import Foundation
import MapKit
import Contacts

struct Place: Identifiable {
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    init(location: CLLocation) async {
        let geocoder = CLGeocoder()
        do {
            guard let placemark = try await geocoder.reverseGeocodeLocation(location).first else {
                self.init(mapItem: MKMapItem())
                return
            }
            let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
            self.init(mapItem: mapItem)
        } catch {
            print("Error in geocoding: \(error.localizedDescription)")
            self.init(mapItem: MKMapItem())
        }
    }
    
    var name: String {
        self.mapItem.name ?? ""
    }
    
    var latitude: Double {
        self.mapItem.placemark.coordinate.latitude
    }
    
    var longitude: Double {
        self.mapItem.placemark.coordinate.longitude
    }
    
    var address: String {
        let postalAddress = mapItem.placemark.postalAddress ?? CNPostalAddress()
        var address = CNPostalAddressFormatter().string(from: postalAddress)
        address = address.replacingOccurrences(of: "\n", with: ", ")
        
        return address
    }
}
