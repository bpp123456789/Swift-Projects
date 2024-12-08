//
//  Activity.swift
//  ControlFlow
//
//  Created by William Petrik on 12/5/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Activity: Codable, Identifiable {
    @DocumentID var id: String?
    var name = ""
    var description = ""
    var difficulty = 1
    var latitude = 0.0
    var longitude = 0.0
    var hint = ""
}

extension Activity {
    static var preview: Activity {
        Activity(id: "1",
                 name: "Geocache #1",
                 description: "This geocache is a pretty easy one to get introduced to. Usually there is some sort of puzzle to go along with it, but there is just a log inside to say that you me",
                 difficulty: 2,
                 latitude: 42.36920022102087,
                 longitude: -70.86822146953111,
                 hint: "this is the ocean silly")
    }
}
