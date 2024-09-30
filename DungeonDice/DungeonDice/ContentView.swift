//
//  ContentView.swift
//  DungeonDice
//
//  Created by William Petrik on 9/29/24.
//

import SwiftUI

struct ContentView: View {
    
    
    @State private var resultMessage = ""
    
    
    var body: some View {
        
            VStack {
                titleView
                
                Spacer()
                
                resultMessageView
                
                Spacer()
                
                ButtonLayout(resultMessage: $resultMessage)
                
                
                
            }
            .padding()
        
        
    }
    
  
}

extension ContentView {
    private var titleView: some View {
        Text("Dungeon Dice")
            .font(.largeTitle)
            .fontWeight(.black)
            .foregroundStyle(.red)
    }
    private var resultMessageView: some View {
        Text(resultMessage)
            .font(.largeTitle)
            .fontWeight(.black)
            .multilineTextAlignment(.center)
            .frame(height: 150)
    }
  
}


#Preview {
    ContentView()
}
