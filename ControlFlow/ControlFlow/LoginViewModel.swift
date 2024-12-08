//
//  LoginViewModel.swift
//  ControlFlow
//
//  Created by William Petrik on 12/5/24.
//

import Foundation
import FirebaseFirestore

@Observable
class LoginViewModel {
    
    static func saveLogin(login: Login) async -> String? {
        let db = Firestore.firestore()
        
        if let id = login.id {
            do {
                try db.collection("logins").document(id).setData(from: login)
                print("login saved")
                return id
            } catch {
                print("Error saving login: \(error)")
                return id
            }
        } else {
            do {
                let docRef = try db.collection("logins").addDocument(from: login)
                print("Login added successfully")
                return docRef.documentID
            } catch {
                print("Error adding login: \(error)")
                return nil
            }
        }
    }
}
