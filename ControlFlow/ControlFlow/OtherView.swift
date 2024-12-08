//
//  OtherView.swift
//  ControlFlow
//
//  Created by William Petrik on 12/4/24.
//

import SwiftUI

struct OtherView: View {
    private var mapLinks = ["https://www.newenglandbasecamp.org/wp-content/uploads/2022/11/New_England_Base_Camp_Map-pdf.jpg", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUx7ZGW9F27CWOZINRHUT_0MUJvVsZCt_P3g&s", "https://www.mass.gov/files/2017-08/blue-hills-trail-map-2016.pdf"]
    private var mapNames = ["NEBC Cartoon Map", "NEBC Traditional Map", "Blue Hills Map"]
    private var mapImages = ["mappin", "map", "globe"]
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            maps
            staff
            contact
            
            Spacer()
        }
        .sheet(isPresented: $isPresented) {
            LoginView()
        }
    }
}

extension OtherView {
    var maps: some View {
        VStack(alignment: .leading){
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 50)
                    .tint(.gray)
                    .opacity(0.2)
                
                Text("Maps")
                    .font(.title)
                    .padding(.horizontal)
                    
            }
            
            List(0...mapNames.count - 1, id: \.self) { num in
                
                Link(destination: URL(string: mapLinks[num])!) {
                    HStack{
                        Image(systemName: mapImages[num])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(.trailing)
                        
                        Text(mapNames[num])
                            .font(.title3)
                    }
                }
            }
            .listStyle(.plain)
            .frame(height: 130)
            .scrollDisabled(true)
        }
    }
}

extension OtherView {
    var staff: some View {
        VStack(alignment: .leading){
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 50)
                    .tint(.gray)
                    .opacity(0.2)
                
                Text("Staff")
                    .font(.title)
                    .padding(.horizontal)
            }
            
            List {
                if !AppData.shared.isStaff {
                    Button {
                        isPresented.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .padding(.trailing)
                            
                            
                            Text("Staff Login")
                                .font(.title3)
                        }
                    }
                } else {
                    Button {
                        AppData.shared.isStaff = false
                    } label: {
                        HStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .padding(.trailing)
                            
                            
                            Text("Staff Logout")
                                .font(.title3)
                        }
                        
                    }
                }
            }
            .listStyle(.plain)
            .frame(height: 50)
            .scrollDisabled(true)
        }
    }
}

extension OtherView {
    var contact: some View {
        VStack(alignment: .leading){
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 50)
                    .tint(.gray)
                    .opacity(0.2)
                
                Text("Contact")
                    .font(.title)
                    .padding(.horizontal)
            }
            Text("Monday - Saturday")
                .font(.title3)
                .padding(.horizontal)
            
            Text("Hours: 9:30am - 4:30pm")
                .font(.title3)
                .padding(.horizontal)
            
            Text("Phone: 617-615-0004")
                .font(.title3)
                .padding(.horizontal)
            
            Text("Email: help@scoutspirit.org")
                .font(.title3)
                .padding(.horizontal)
            
        }
    }
}

#Preview {
    OtherView()
}
