//
//  PhotoView.swift
//  ControlFlow
//
//  Created by William Petrik on 12/4/24.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
    @State var area: Area
    @State private var photo = Photo()
    @State private var data = Data()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var pickerIsPresented = true
    @State private var selectedImage = Image(systemName: "photo")
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Spacer()
            
            selectedImage
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            Button("Select Photo") {
                pickerIsPresented = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.baseCampTeal)
           
            
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            Task {
                                await PhotoViewModel.saveImage(area: area, photo: photo, data: data)
                                dismiss()
                            }
                            
                        }
                    }
                }
                .photosPicker(isPresented: $pickerIsPresented, selection: $selectedPhoto)
                .onChange(of: selectedPhoto) {
                    Task {
                        do {
                            if let image = try await selectedPhoto?.loadTransferable(type: Image.self) {
                                selectedImage = image
                            }
                            
                            guard let transferredData = try await selectedPhoto?.loadTransferable(type: Data.self) else {
                                
                                return
                            }
                            data = transferredData
                            
                        } catch {
                            print(" error in selecting photo")
                        }
                    }
                }
        }
    }
}

#Preview {
    PhotoView(area: .init())
}
