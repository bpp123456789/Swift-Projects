//
//  PlaceLookupView.swift
//  ControlFlow
//
//  Created by William Petrik on 12/5/24.
//

import SwiftUI
import MapKit

struct PlaceLookupView: View {
    let locationManager: LocationManager
    @Binding var selectedPlace: Place?
    @State private var searchTask: Task<Void, Never>?
    @State var placeVM = PlaceLookupViewModel()
    @State private var searchText = ""
    @State private var searchRegion = MKCoordinateRegion()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Group {
                if searchText.isEmpty {
                    ContentUnavailableView("No Results", systemImage: "mappin.slash")
                } else {
                    List(placeVM.places) { place in
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.title2)
                            Text(place.address)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        .onTapGesture {
                            selectedPlace = place
                            dismiss()
                        }
                    }
                    .listStyle(.plain)
                }
            }
            
            
            
            .navigationTitle("Location Search")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .autocorrectionDisabled()
        .onDisappear {
            searchTask?.cancel()
        }
        .onAppear{
            searchRegion = locationManager.getRegionAroundCurrentLocation() ?? MKCoordinateRegion()
        }
        .onChange(of: searchText) { oldValue, newValue in
            searchTask?.cancel()
            guard !newValue.isEmpty else {
                placeVM.places.removeAll()
                return
            }
            
            searchTask = Task {
                do {
                    try await Task.sleep(for: .milliseconds(300))
                    if Task.isCancelled {
                        return }
                    if searchText == newValue {
                        try await placeVM.search(text: newValue, region: searchRegion)
                    }
                } catch {
                    if !Task.isCancelled {
                        print(" Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

#Preview {
    PlaceLookupView(locationManager: LocationManager(), selectedPlace: .constant(Place(mapItem: MKMapItem())))
}
