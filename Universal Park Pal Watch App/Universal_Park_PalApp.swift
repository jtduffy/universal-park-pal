//
//  Universal_Park_PalApp.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 8/7/25.
//

import SwiftUI

@main
struct Universal_Park_Pal_Watch_AppApp: App {
    @StateObject private var dataManager = DataManagerService()
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(dataManager)
        }
    }
}
