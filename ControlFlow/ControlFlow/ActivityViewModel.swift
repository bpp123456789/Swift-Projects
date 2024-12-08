//
//  ActivityViewModel.swift
//  ControlFlow
//
//  Created by William Petrik on 12/6/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class ActivityViewModel {
    
    static func saveActivity(activity: Activity) async -> String?{
        let db = Firestore.firestore()
        
        if let id = activity.id {
            do {
                try db.collection("activity").document(id).setData(from: activity)
                print("activity saved")
                return id
            } catch {
                print("Error saving activity: \(error)")
                return id
            }
        } else {
            do {
                let docRef = try db.collection("activity").addDocument(from: activity)
                print("activity added successfully")
                return docRef.documentID
            } catch {
                print("Error adding activity: \(error)")
                return nil
            }
        }
    }
    
    static func deleteActivity(actitvity: Activity) {
        let db = Firestore.firestore()
        guard let id = actitvity.id else {
            print("Error deleting activity: No ID")
            return
        }
        
        Task {
            do {
                try await db.collection("activity").document(id).delete()
            } catch {
                print("Error deleting area: \(error.localizedDescription)")
            }
        }
    }
}
