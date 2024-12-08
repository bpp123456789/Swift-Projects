//
//  CurrentView.swift
//  ControlFlow
//
//  Created by William Petrik on 12/2/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct CurrentView: View {
    var body: some View {
        TabView {
            Tab("Areas", systemImage: "map") {
                AreaListView()
            }
            
            Tab("Activities", systemImage: "questionmark.app") {
                ActivityListView()
            }
            
            Tab("Other", systemImage: "slider.horizontal.3"){
                OtherView()
            }
        }
        .tint(.baseCampTeal)
    }
}

#Preview {
    CurrentView()
}
