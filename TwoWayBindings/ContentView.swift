//
//  ContentView.swift
//  TwoWayBindings
//
//  Created by William Petrik on 9/15/24.
//

import SwiftUI

struct ContentView: View {
    @State private var pressCount = 0
    @State private var toggleIsOn = true
    @State private var name = ""
    @State private var selectedColor: Color = .red
    @State private var selectedDate = Date()
    @State private var stepperValue = 0
    var body: some View {
        
        VStack {
            Spacer()
            
            Text("Press Count: \(pressCount)")
            
            Button("Press Me") {
                pressCount += 1
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
            TextField("Enter a name", text: $name)
                .textFieldStyle(.roundedBorder)
            Text("Name entered: \(name)")
            
            Spacer()
            
            Toggle("Toggle is \(toggleIsOn ? "on" : "off")", isOn: $toggleIsOn )
            
            Spacer()
            
            Rectangle()
                .fill(selectedColor)
                .frame(width: 100, height: 100)
            
            ColorPicker("Pick a color:", selection: $selectedColor)
            
            Spacer()
            
            DatePicker("Pick a date", selection: $selectedDate)
            Text("Selcted date is: \(selectedDate.formatted(date: .abbreviated, time: .shortened))")
            
            Spacer()
            
            Stepper("Stepper value: \(stepperValue)", value: $stepperValue, in: 0...15)
            
            Spacer()
        }
        .font(.title2)
        .padding()
    }
}

#Preview {
    ContentView()
}
