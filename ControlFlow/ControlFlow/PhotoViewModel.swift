//
//  PhotoViewModel.swift
//  ControlFlow
//
//  Created by William Petrik on 12/4/24.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftUI

@Observable
class PhotoViewModel {
    static func saveImage(area: Area, photo: Photo, data: Data) async {
        guard let id = area.id else {
            print("error, should never have been called without a valid area.id")
            return
        }
        let storage = Storage.storage().reference()
        let metadata = StorageMetadata()
        if photo.id == nil {
            photo.id = UUID().uuidString
        }
        
        metadata.contentType = "image/jpeg"
        let path = "\(id)/\(photo.id ?? "n/a")"
        
        do {
            let storageref = storage.child(path)
            let returnedMetaData = try await storageref.putDataAsync(data, metadata: metadata)
            
            guard let url = try? await storageref.downloadURL() else {
                print("could not get download url")
                return
            }
            photo.imageURLString = url.absoluteString
            print("photo.imageURLString: \(photo.imageURLString)")
            
            let db = Firestore.firestore()
            do {
                try db.collection("areas").document(id).collection("photos").document(photo.id ?? "n/a").setData(from: photo)
            } catch {
                print("could not update data in areas/\(id)/photos/\(photo.id ?? "n/a"): \(error.localizedDescription)")
            }
            
        } catch {
            print("error saving image to storage: \(error.localizedDescription)")
        }
    }
    
    static func deletePhotos(area: Area) async {
        guard let id = area.id else {
            print("error, should never have been called without a valid area.id")
            return
        }
        let storage = Storage.storage().reference()
        let path = "\(id)/photos"
        let storageRef = storage.child(path)
        do{
            storageRef.delete(completion: nil)
        } catch {
            print("could not delete phtos")
        }
    }
    
}
