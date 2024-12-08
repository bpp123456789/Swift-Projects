//
//  ActivityListView.swift
//  ControlFlow
//
//  Created by William Petrik on 12/6/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ActivityListView: View {
    @FirestoreQuery(collectionPath: "activity") var activities: [Activity]
    @State var sheetIsPresented = false
    
    var body: some View {
        NavigationStack {
            List(activities) { activity in
                NavigationLink {
                    if AppData.shared.isStaff {
                        ActivityViewStaff(activity: activity)
                    } else {
                        ActivityView(activity: activity)
                    }
                } label: {
                    
                    Text(activity.name)
                        .font(.title2)
                }
            }
            .listStyle(.plain)
            .navigationTitle("NEBC Activities")
            
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
                    ActivityViewStaff(activity: Activity())
                }
            }
        }
    }
    
}

#Preview {
    ActivityListView()
}
