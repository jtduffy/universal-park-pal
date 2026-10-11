//
//  Universal_Park_PalApp.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 8/7/25.
//

import SwiftUI

@main
struct Universal_Park_Pal_Watch_AppApp: App {
    @StateObject private var dataManager = ParkInformationService()
    @StateObject private var lockerStore = SavedLockerStore()
    @StateObject private var parkingStore = SavedParkingStore()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(dataManager)
                .environmentObject(lockerStore)
                .environmentObject(parkingStore)
        }
        .onChange(of: scenePhase, initial: true) {
            if scenePhase == .active {
                parkingStore.purgeExpired()
                lockerStore.purgeExpired()
            }
        }
    }
}
