//
//  Login.swift
//  ControlFlow
//
//  Created by William Petrik on 12/5/24.
//

import Foundation
import FirebaseFirestore

struct Login: Identifiable, Codable {
    @DocumentID var id: String?
    var isStaff = false
    var email: String
}
