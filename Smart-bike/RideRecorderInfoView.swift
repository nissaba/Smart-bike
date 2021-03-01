//
//  RideRecorderInfoView.swift
//  Smart-bike
//
//  Created by Pascale Beaulac on 2021-02-23.
//

import SwiftUI

struct RideRecorderInfoView: View {
    @EnvironmentObject var periphController: SBPreripheralController
    @ObservedObject var peripheral: SBRecorderPeripheralModel
        
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .trailing, spacing: 1, content: {
                    Text("Name: ")
                    Text("Battery Level: ")
                    Text("Firmware Version: ")
                    Text("Memory Usage: ")
                    Text("Number of Ride: ")
                    Text("Number of ANT+ Device: ")
                })
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
                VStack(alignment: .leading, spacing: 1, content: {
                    Text(periphController.connectedPeripheral?.name ?? "Unnamed")
                    Text("\(periphController.connectedPeripheral?.batteryLevel ?? 0)%")
                    Text("1.0.99")
                    Text("50%")
                    Text("4")
                    Text("3")
                })
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            HStack{
                Button("View Rides") {
                    
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.blue, lineWidth: 1))
                .padding()
                Button("View ANT+") {
                    
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.blue, lineWidth: 1))
                .padding()
            }
        }
        
    }
}
