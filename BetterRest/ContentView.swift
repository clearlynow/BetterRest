//
//  ContentView.swift
//  BetterRest
//
//  Created by Alison Gorman on 1/6/21.
//

import SwiftUI

let model = SleepCalculator()

struct ContentView: View {
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false


    
    func calculateBedtime() -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: sleepTime)
        } catch {
            return "Error"
        }
    }
    
    var body: some View {
        
        NavigationView{
            Form {
                
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }

                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                        }
                    }
                
                Section(header: Text("Daily coffee intake")) {
                    //Stepper(value: $coffeeAmount, in: 1...20) {
                    Picker(selection: $coffeeAmount, label: Text("Cups of coffee")) {
                        ForEach(1..<21) {
                            if $0 > 1 {
                                Text("\($0) cups")
                            } else {
                                Text("1 cup")
                            }
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .labelsHidden()
                }
                
                Section(header: Text("Recommended Bed Time")){
                    Text(calculateBedtime())
                        .font(.largeTitle)
                }
            }
        
            .navigationBarTitle("BetterRest")

    }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
