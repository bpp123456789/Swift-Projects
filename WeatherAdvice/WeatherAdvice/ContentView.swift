//
//  ContentView.swift
//  WeatherAdvice
//
//  Created by William Petrik on 9/30/24.
//

import SwiftUI

struct ContentView: View {
    @FocusState private var isFocused: Bool
    @State private var adviceMessage = ""
    @State private var inputTemp = ""
    @State private var imageName = ""
    
    var body: some View {
        VStack {
            Text("Weather Advice")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.cyan)
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .padding()
                .animation(.default, value: imageName)
            
            
            Text(adviceMessage)
                .font(.title)
                .frame(height: 80)
                .minimumScaleFactor(0.5)
                .animation(.default, value: adviceMessage)
            
            HStack {
                Text("What is the temp?")
                    .font(.title)
                
                
                TextField("", text: $inputTemp)
                    .focused($isFocused)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 65)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray, lineWidth: 2)
                    }
                    .onChange(of: isFocused, {
                        if isFocused {
                            inputTemp = ""
                            imageName = ""
                            adviceMessage = "Please enter a valid temperature"
                        }
                    })

            }
            Button("Get Advice") {
                giveAdvice()
                isFocused = false
                
            }
            .buttonStyle(.borderedProminent)
            .tint(.teal)
            .font(.title2)
            .disabled(inputTemp.isEmpty)
            .padding()
            
        }
    }
    func giveAdvice() {
        guard let tempInt = Int(inputTemp) else {
            adviceMessage = "Please enter a valid temperature"
            imageName = ""
            return
        }
        switch tempInt {
        case 76...:
            adviceMessage = "It's hot"
            imageName = "hot"
        case 63..<76:
            adviceMessage = "Nice and mild"
            imageName = "warm"
        case 45..<63:
            adviceMessage = "You are going to need a sweater"
            imageName = "mild"
        case 33..<45:
            adviceMessage = "You are going to need a coat"
            imageName = "cool"
        default:
            adviceMessage = "Bundle up! It's freezing"
            imageName = "freezing"
        }
    }
}

#Preview {
    ContentView()
}
