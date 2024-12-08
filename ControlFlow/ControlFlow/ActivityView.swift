//
//  ActivityView.swift
//  ControlFlow
//
//  Created by William Petrik on 12/6/24.
//

import SwiftUI

struct ActivityView: View {
    @State var activity: Activity
    @State private var hintIsShown = false
    private var activityColor: Color {
        switch activity.difficulty {
        case 1:
            return Color.green
        case 2:
            return Color.lime
        case 3:
            return Color.yellow
        case 4:
            return Color.orange
        default:
            return Color.red
        }
    }
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(activity.name)
                .font(.largeTitle)
                .padding(.horizontal)
            
            Rectangle()
                .frame(height: 2)
            
            Text("Latitude, Longitude:")
                .font(.title)
                .padding(.horizontal)
            
            Text("\(activity.latitude), \(activity.longitude)")
                .font(.title3)
                .padding(.horizontal)
                .padding(.bottom)
            
            Text("Description:")
                .font(.title)
                .padding(.horizontal)
            
            Text("\(activity.description)")
                .font(.title3)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
                .padding(.bottom)
            
            
            Text("Difficulty: \(activity.difficulty)")
                .font(.title2)
                .padding(.horizontal)
            
            HStack {
                Spacer()
                
                ForEach(1...5, id: \.self) { num in
                    if num <= activity.difficulty {
                        Image(systemName: "square.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(activityColor)
                        Spacer()
                    } else {
                        Image(systemName: "square")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(activityColor)
                        Spacer()
                    }
                    
                }
            }
            
            HStack{
                Spacer()
                Button {
                    hintIsShown.toggle()
                } label: {
                    Image(systemName: "exclamationmark.questionmark")
                    
                    Text("Toggle Hint")
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            
            if hintIsShown {
                Text(activity.hint)
                    .font(.title3)
                    .padding()
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            
            
        }
        
    }
}

#Preview {
    ActivityView(activity: Activity.preview)
}
