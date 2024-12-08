//
//  LocationSearchViewModel.swift
//  ControlFlow
//
//  Created by William Petrik on 12/6/24.
//

import Foundation
import MapKit

@Observable
class LocationSearchViewModel: NSObject, MKLocalSearchCompleterDelegate {
    private(set) var searchResults: [MKLocalSearchCompletion] = [] //result of our search
    private let completer = MKLocalSearchCompleter() // This object takes in text to search on and returns the results
    var error: Error?
    
    //by adding the delegate below we are saying that completer above can be automatically called by ios when tasks need to be performed
    override init() {
        super.init()
        completer.delegate = self
    }
    
    func updateSearchText(_ text: String) {
        if text.isEmpty {
            searchResults = []
        }
        completer.queryFragment = text
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        self.error = error
    }
    
    //returns a locationResult which contains lat and long
    func returnLocationResults( for completion: MKLocalSearchCompletion) async throws -> LocationResult {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        guard let mapItem = response.mapItems.first else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No location found"])
        }
        return LocationResult(placeName: completion.title, address: completion.subtitle, coordinates: mapItem.placemark.coordinate)
    }
    
}
