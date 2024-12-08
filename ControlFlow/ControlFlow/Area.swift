//
//  Area.swift
//  ControlFlow
//
//  Created by William Petrik on 12/2/24.
//

import Foundation
import FirebaseFirestore

struct Area: Identifiable, Codable {
    @DocumentID var id: String?
    var name = ""
    var description = ""
    var wait = 0
    var lastUpdated = Date()
}

extension Area {
    static var preview: Area {
        let newArea = Area(id: "1", name: "Climbing Area", description: "Have fun with Mike and Billy doing some rappeling and climbing on Lookout Rock", wait: 3, lastUpdated: Date())
        return newArea
    }
}
