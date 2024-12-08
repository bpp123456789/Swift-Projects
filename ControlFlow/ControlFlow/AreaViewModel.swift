//
//  AreaViewModel.swift
//  ControlFlow
//
//  Created by William Petrik on 12/2/24.
//

import Foundation
import FirebaseFirestore

@Observable
class AreaViewModel {
    
    static func saveArea(area: Area) async -> String?{
        let db = Firestore.firestore()
        
        if let id = area.id {
            do {
                try db.collection("areas").document(id).setData(from: area)
                print("Area saved")
                return id
            } catch {
                print("Error saving area: \(error)")
                return id
            }
        } else {
            do {
                let docRef = try db.collection("areas").addDocument(from: area)
                print("Area added successfully")
                return docRef.documentID
            } catch {
                print("Error adding area: \(error)")
                return nil
            }
        }
    }
    
    static func deleteArea(area: Area) {
        let db = Firestore.firestore()
        guard let id = area.id else {
            print("Error deleting area: No ID")
            return
        }
        
        Task {
            do {
                try await db.collection("areas").document(id).delete(completion: { _ in })
            } catch {
                print("Error deleting area: \(error.localizedDescription)")
            }
        }
    }
}
