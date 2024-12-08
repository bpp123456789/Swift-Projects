//
//  LocationResult.swift
//  ControlFlow
//
//  Created by William Petrik on 12/6/24.
//

import Foundation
import CoreLocation

struct LocationResult: Identifiable, Equatable {
    let id = UUID().uuidString
    let placeName: String
    let address: String
    let coordinates: CLLocationCoordinate2D
    
    static func == (lhs: LocationResult, rhs: LocationResult) -> Bool {
        lhs.id == rhs.id
    }
}
