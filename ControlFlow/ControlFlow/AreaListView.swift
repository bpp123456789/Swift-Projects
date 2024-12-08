//
//  ContentView.swift
//  ControlFlow
//
//  Created by William Petrik on 12/2/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct AreaListView: View {
    @FirestoreQuery(collectionPath: "areas") var areas: [Area]
    @State var sheetIsPresented = false
    
    
    var body: some View {
        NavigationStack {
            List(areas) { area in
                NavigationLink {
                    if AppData.shared.isStaff {
                        AreaViewStaff(area: area)
                    } else {
                        AreaView(area: area)
                    }
                } label: {
                    
                    Text(area.name)
                        .font(.title2)
                }
            }
            .listStyle(.plain)
            .navigationTitle("NEBC Areas")
            
            .toolbar {
                if AppData.shared.isStaff {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            sheetIsPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    AreaViewStaff(area: Area())
                }
            }
        }
    }
    
}

#Preview {
    AreaListView()
}
