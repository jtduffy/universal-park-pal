//
//  ContentView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 8/7/25.
//
import SwiftUI

struct MainView: View {
    @EnvironmentObject var dataManager: DataManagerService
    
    // 1. Change this to an Optional Park object
    @State private var selectedParkForLockers: Park? = nil
    @State private var selectedParkForPaidLockers: Park? = nil
    
    var body: some View {
        NavigationStack {
            List {
                // 1. The Park Rows
                ForEach(dataManager.parks) { park in
                    ParkRowView(park: park, selectedParkForLockers: $selectedParkForLockers, selectedParkForPaidLockers: $selectedParkForPaidLockers)
                }
                
                // 2. The Reset Button (Now scrollable)
                Section {
                    Button(role: .destructive, action: globalReset) {
                        Label("Clear All Data", systemImage: "arrow.counterclockwise.circle")
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Universal Park Pal")
            .navigationDestination(item: $selectedParkForLockers) { park in
                LockerListView(
                    isPresented: Binding(
                        get: { selectedParkForLockers != nil },
                        set: { isPresenting in
                            if !isPresenting { selectedParkForLockers = nil }
                        }
                    ),
                    lockers: park.lockers, mode: .ride
                )
            }
            .navigationDestination(item: $selectedParkForPaidLockers) { park in
                // This would lead to your view for paid locker locations
                LockerListView(
                    isPresented: Binding(
                        get: { selectedParkForPaidLockers != nil },
                        set: { if !$0 { selectedParkForPaidLockers = nil } }
                    ),
                    lockers: park.paidLockers, mode: .paid
                )
            }
        }
    }
    
    private func globalReset() {
        // Play a distinct haptic
        WKInterfaceDevice.current().play(.stop)
        
        // Wipe all keys
        let keys = [
            "savedLockerName", "savedLockerSection", "savedLockerNumber",
            "savedPaidLockerName", "savedPaidLockerSection", "savedPaidLockerNumber",
            "savedParkingLotId", "savedSection", "savedLevel", "savedRow"
        ]
        
        keys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
        
        // Force UI refresh (AppStorage handles this automatically once keys change)
    }
}

#Preview {
    MainView()
        .environmentObject(DataManagerService())
}
