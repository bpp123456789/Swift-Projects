//
//  ActivityViewStaff.swift
//  ControlFlow
//
//  Created by William Petrik on 12/6/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct ActivityViewStaff: View {
    @State var locationManager = LocationManager()
    @State var locationSearchVM = LocationSearchViewModel()
    @State var complete = MKLocalSearchCompletion()
    @State private var alertIsPresented = false
    @State var activity: Activity
    @State var selectedLocation: LocationResult?
    @State private var locationSheetPresented = false
    @Environment(\.dismiss) var dismiss
    
    private var activityColor: Color {
        switch activity.difficulty {
        case 1:
            return Color.green
        case 2:
            return Color.lime
        case 3:
            return Color.yellow
        case 4:
            return Color.orange
        default:
            return Color.red
        }
    }
    
    var body: some View {
        ScrollView {
            TextField("Title", text: $activity.name)
                .font(.largeTitle)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Rectangle()
                .frame(height: 2)
            
            TextField("Description", text: $activity.description, axis: .vertical)
                .font(.title3)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.leading)
                .lineLimit(8, reservesSpace: true)
            
            
            Text("\(activity.latitude), \(activity.longitude)")
                .font(.title3)
                .padding(.horizontal)
                .padding(.bottom)
            HStack {
                Button {
                    locationSheetPresented.toggle()
                } label: {
                    Image(systemName: "mappin")
                    
                    Text("Insert Location")
                }
                Button {
                    alertIsPresented.toggle()
                } label: {
                    Image(systemName: "location.fill")
                    
                    Text("Current Location")
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.baseCampTeal)
            
            Text("Difficulty: \(activity.difficulty)")
                .font(.title2)
            
            HStack {
                Spacer()
                ForEach(1...5 , id: \.self) { num in
                    Button {
                        activity.difficulty = num
                    } label: {
                        if num <= activity.difficulty {
                            Image(systemName: "square.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .tint(activityColor)
                        } else {
                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .tint(activityColor)
                        }
                    }
                    
                    Spacer()
                }
            }
            
            TextField("Hint", text: $activity.hint, axis: .vertical)
                .font(.title3)
                .padding()
                .multilineTextAlignment(.leading)
                .lineLimit(5, reservesSpace: true)
            
            Button("Delete Activity") {
                ActivityViewModel.deleteActivity(actitvity: activity)
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .padding()
            
            
        }
        .sheet(isPresented: $locationSheetPresented) {
            LocationSearchView(selectedLocation: $selectedLocation)
        }
        .onChange(of: locationSheetPresented) {
            activity.latitude = selectedLocation?.coordinates.latitude ?? 0.0
            activity.longitude = selectedLocation?.coordinates.longitude ?? 0.0
        }
        .alert("Do you allow us to use your current location", isPresented: $alertIsPresented) {
            Button("Cancel"){
                alertIsPresented = false
            }
            Button("Allow"){
                locationManager.requestLocation()
                activity.latitude = locationManager.location?.coordinate.latitude ?? 0.0
                activity.longitude = locationManager.location?.coordinate.longitude ?? 0.0
                
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        guard let id = await ActivityViewModel.saveActivity(activity: activity) else {
                            print("Error activity from save button")
                            return }
                        activity.id = id
                    }
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    ActivityViewStaff(activity: Activity())
}
