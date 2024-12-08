//
//  AreaView.swift
//  ControlFlow
//
//  Created by William Petrik on 12/2/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct AreaView: View {
    @FirestoreQuery(collectionPath: "areas") var fsPhotos: [Photo]
    @State var area: Area
    let numBars = 5
    @State var photoNum = 0
    
    private var photos: [Photo] {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return [Photo.preview, Photo.preview]
        }
        return fsPhotos
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Group {
                Text("\(area.name)")
                    .font(.largeTitle)
                    .padding(.horizontal)
                
                if !photos.isEmpty {
                    ZStack {
                        Rectangle()
                            .frame(width: .infinity, height: UIScreen.main.bounds.height * 0.25)
                        
                        HStack {
                            Spacer()
                            
                            let url = URL(string: photos[photoNum].imageURLString)
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(height: UIScreen.main.bounds.height * 0.25)
                            
                            Spacer()
                        }
                        
                        HStack {
                            if photoNum > 0 {
                                Button {
                                    photoNum -= 1
                                } label: {
                                    Image(systemName: "arrowshape.backward")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30)
                                }
                            }
                            
                            Spacer()
                            
                            if photoNum < photos.count - 1 {
                                Button {
                                    photoNum += 1
                                } label: {
                                    Image(systemName: "arrowshape.forward")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30)
                                }
                                
                            }
                            
                        }
                    }
                }
                
                
                Rectangle()
                    .frame(height: 1)
                
                Text("Description: ")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                
                Text(area.description)
                    .padding(.horizontal)
                    .padding(.bottom)
                
                Text("Wait Time: \(area.wait) minutes")
                    .bold()
                    .padding(.horizontal)
                
                HStack {
                    
                    makeBar(wait: area.wait)
                }
            }
            
            Spacer()
            
            Text("Last Updated: \(area.lastUpdated.formatted(date: .omitted, time: .shortened))")
                .padding()
        }
        .task {
            $fsPhotos.path = "areas/\(area.id ?? "")/photos"
        }
        
        
    }
    @ViewBuilder func makeBar(wait: Int) -> some View {
        var waitColor: Color
        var placement: Int
        switch wait {
        case 0...4:
            waitColor = Color.green
            placement = 1
        case 5...14:
            waitColor = Color.lime
            placement = 2
        case 15...29:
            waitColor = Color.yellow
            placement = 3
        case 30...40:
            waitColor = Color.orange
            placement = 4
        default:
            waitColor = Color.red
            placement = 5
        }
        
        return HStack {
            Spacer()
            ForEach((1...5), id: \.self) { num in
                if num <= placement {
                    Image(systemName: "square.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(waitColor)
                    Spacer()
                } else {
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(waitColor)
                    Spacer()
                }
            }
            
        }
    }
}



#Preview {
    NavigationStack {
        AreaView(area: Area.preview)
    }
}
