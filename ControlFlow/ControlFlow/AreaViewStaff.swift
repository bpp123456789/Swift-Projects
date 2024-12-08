//
//  AreaViewStaff.swift
//  ControlFlow
//
//  Created by William Petrik on 12/2/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct AreaViewStaff: View {
    @State var area: Area
    @State var areaVM = AreaViewModel()
    @State var waitString = ""
    @FirestoreQuery(collectionPath: "areas") var fsPhotos: [Photo]
    @State private var path = ""
    @State var photoNum = 0
    @State var photo: Photo?
    @State private var alertMessage = "You must save before importing any images"
    @State private var alertIsShowing = false
    @State private var photoSheetIsPresented = false
    
    private var photos: [Photo] {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return [Photo.preview]
        }
        return fsPhotos
    }
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ScrollView {
                    TextField("Area", text: $area.name)
                        .font(.largeTitle)
                        .textFieldStyle(.roundedBorder)
                        .bold()
                        .padding(.horizontal)
                        .keyboardShortcut(.escape)
                
                    ZStack {
                        Rectangle()
                            .frame(width: .infinity, height: UIScreen.main.bounds.height * 0.25)
                        
                        HStack {
                            Spacer()
                            
                            if photos.isEmpty || photos.count == photoNum {
                                Button {
                                    if area.id == nil {
                                        alertIsShowing.toggle()
                                    } else {
                                        photoSheetIsPresented.toggle()
                                    }
                                } label: {
                                    Text("Add Photo")
                                    Image(systemName: "camera")
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(Color.baseCampTeal)
                                
                            } else {
                                let url = URL(string: photos[photoNum].imageURLString)
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(height: UIScreen.main.bounds.height * 0.25)
                            }
                            
                            
                            
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
                            
                            if photoNum < photos.count {
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
                
                TextField("Description", text: $area.description, axis: .vertical)
                    .font(.title3)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.leading)
                    .lineLimit(5, reservesSpace: true)
                
                
                TextField("Wait Time in Minutes: ", text: $waitString)
                    .font(.title3)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.asciiCapableNumberPad)
                
                Button("Change Wait Time") {
                    area.wait = Int(waitString) ?? 0
                }
                .buttonStyle(.borderedProminent)
                .tint(.baseCampTeal)
                
                AreaView(area: area).makeBar(wait: area.wait)
                
                Spacer()
                
                Button("Delete Area") {
                    Task {
                        await PhotoViewModel.deletePhotos(area: area)
                    }
                    AreaViewModel.deleteArea(area: area)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            if area.id != nil {
                $fsPhotos.path = "areas/\(area.id ?? "")/photos"
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveArea()
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $photoSheetIsPresented) {
            PhotoView(area: area)
        }
        .alert(alertMessage, isPresented: $alertIsShowing) {
            Button("Cancel", role:.cancel) {}
            Button("Save") {
                Task {
                    guard let id = await AreaViewModel.saveArea(area: area) else {
                        print("Error area from save button")
                        return }
                    area.id = id
                    photoSheetIsPresented.toggle()
                }
                
            }
        }
    }
    func saveArea() {
        Task {
            guard let id = await AreaViewModel.saveArea(area: area) else {
                print("Error area from save button")
                return }
        }
    }
}

#Preview {
    AreaViewStaff(area: Area.preview)
}
