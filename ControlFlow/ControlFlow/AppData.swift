//
//  AppData.swift
//  ControlFlow
//
//  Created by William Petrik on 12/5/24.
//

import Foundation

@Observable
class AppData {
    static let shared = AppData()
    var isStaff: Bool = false
    
    private init() {}
}
