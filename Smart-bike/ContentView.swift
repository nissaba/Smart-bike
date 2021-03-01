//
//  ContentView.swift
//  Smart-bike
//
//  Created by Pascale Beaulac on 2021-02-18.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var peripheralController: SBPreripheralController
    @State var selection: UUID?
    @State var showDetails = false
//    @ObservedObject var device
    var body: some View {
        NavigationView{
            VStack {
                Button("Scan for BLE Devices") {
                    self.peripheralController.starScaning()
                }
                .foregroundColor(.black)
                .padding()
                .background(Color.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .padding()

                if let device = self.peripheralController.foundPeriferal {
                    NavigationLink(
                        destination: RideRecorderInfoView(),
                        isActive: $showDetails,
                        label: {
                            
                        })
                        
                    VStack{
                        Text("Device Found")
                        Button(action: {
                            self.peripheralController.connectDevice()
                            showDetails = true
                        }, label: {
                            Text("Connect to \n" + device.name)
                                .multilineTextAlignment(.center)
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                        })
                        
                    }
                    .padding()
                }
                Spacer()
            }
            .environmentObject(SBPreripheralController.shared)
            .navigationTitle("BLE List")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SBPreripheralController.shared)
    }
}
