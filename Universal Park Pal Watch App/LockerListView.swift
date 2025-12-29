//
//  LockerListView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/22/25.
//

import SwiftUI
import CoreLocation

struct LockerListView: View {
    @Binding var isPresented: Bool
    let lockers: [Locker]
    let mode: LockerType
    
    // 1. Add the LocationManager
    @StateObject private var locationManager = LocationManagerService()
    
    // 2. Create a computed property to handle the sorting
    var sortedLockers: [Locker] {
        guard let userLoc = locationManager.userLocation else {
            return lockers // Return default order if no location yet
        }
        
        return lockers.sorted { locker1, locker2 in
            let loc1 = CLLocation(latitude: locker1.location.latitude, longitude: locker1.location.longitude)
            let loc2 = CLLocation(latitude: locker2.location.latitude, longitude: locker2.location.longitude)
            
            // Compare distances
            return userLoc.distance(from: loc1) < userLoc.distance(from: loc2)
        }
    }
    
    var body: some View {
        // 3. Use sortedLockers instead of lockers
        List(sortedLockers) { locker in
            NavigationLink(destination: LockerSelectionView(
                isPresented: $isPresented,
                locker: locker,
                mode: mode
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(locker.name)
                            .font(.headline)
                            .lineLimit(1)
                        
                        // Optional: Show distance if we have it
                        if let userLoc = locationManager.userLocation {
                            Spacer()
                            let distance = userLoc.distance(from: CLLocation(latitude: locker.location.latitude, longitude: locker.location.longitude))
                            Text(formatDistance(distance))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text("\(locker.sections) Sections")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(mode == .ride ? "Ride Lockers" : "Paid Lockers")
        .onAppear {
            locationManager.start() // GPS ON when view appears
        }
        .onDisappear {
            locationManager.stop()  // GPS OFF when view vanishes
        }
    }
    
    // Helper to make meters look like "0.2 mi" or "300 ft"
    private func formatDistance(_ meters: Double) -> String {
        let measurement = Measurement(value: meters, unit: UnitLength.meters)
        // Convert to user's preferred locale (miles or km)
        return measurement.formatted(.measurement(width: .abbreviated, usage: .road))
    }
}
