//
//  Smart_bikeApp.swift
//  Smart-bike
//
//  Created by Pascale Beaulac on 2021-02-18.
//

import SwiftUI

@main
struct Smart_bikeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(SBPreripheralController.shared)
        }
    }
}
