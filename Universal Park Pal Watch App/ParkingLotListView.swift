//
//  ParkingLotListView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 10/11/26.
//

import SwiftUI
import CoreLocation

struct ParkingLotListView: View {
    @EnvironmentObject var dataManager: ParkInformationService
    @EnvironmentObject var parkingStore: SavedParkingStore
    @StateObject private var locationManager = LocationManagerService()

    // Closest lot first, falls back to JSON order until we have a fix
    var sortedLots: [ParkingLocation] {
        guard let userLoc = locationManager.userLocation else {
            return dataManager.parkingLocations
        }

        return dataManager.parkingLocations.sorted { lot1, lot2 in
            userLoc.distance(from: lot1.location.clLocation) < userLoc.distance(from: lot2.location.clLocation)
        }
    }

    var body: some View {
        List(sortedLots) { lot in
            NavigationLink(destination: ParkingReminderView(parkingLot: lot, saved: parkingStore.spot(in: lot))) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(lot.name)
                        .font(.headline)

                    if let spot = parkingStore.spot(in: lot) {
                        Label("\(spot.section) · Level \(spot.level) · Row \(spot.row)", systemImage: "checkmark.circle.fill")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Car Locator")
        .onAppear {
            locationManager.start()
        }
        .onDisappear {
            locationManager.stop()
        }
    }
}

#Preview {
    NavigationStack {
        ParkingLotListView()
            .environmentObject(ParkInformationService())
            .environmentObject(SavedParkingStore())
    }
}
