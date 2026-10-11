//
//  LockerListView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/22/25.
//

import SwiftUI
import CoreLocation

struct LockerListView: View {
    @EnvironmentObject var dataManager: ParkInformationService
    @EnvironmentObject var lockerStore: SavedLockerStore
    @StateObject private var locationManager = LocationManagerService()

    // Parks ordered by their closest locker, each with its lockers sorted by distance.
    // Falls back to JSON order until we have a location fix.
    var sortedParks: [(park: Park, lockers: [Locker])] {
        guard let userLoc = locationManager.userLocation else {
            return dataManager.parks.map { ($0, $0.lockers) }
        }

        func distance(_ locker: Locker) -> CLLocationDistance {
            userLoc.distance(from: locker.location.clLocation)
        }

        return dataManager.parks
            .map { park in (park, park.lockers.sorted { distance($0) < distance($1) }) }
            .sorted { group1, group2 in
                let nearest1 = group1.1.first.map(distance) ?? .greatestFiniteMagnitude
                let nearest2 = group2.1.first.map(distance) ?? .greatestFiniteMagnitude
                return nearest1 < nearest2
            }
    }

    // Saved lockers matched back to their park and locker data
    var savedEntries: [(park: Park, locker: Locker, saved: SavedLocker)] {
        lockerStore.sortedLockers.compactMap { saved in
            guard let park = dataManager.parks.first(where: { $0.name == saved.parkName }),
                  let locker = park.lockers.first(where: { $0.name == saved.lockerName }) else {
                return nil
            }
            return (park, locker, saved)
        }
    }

    var body: some View {
        List {
            if !savedEntries.isEmpty {
                Section("My Lockers") {
                    ForEach(savedEntries, id: \.saved.id) { entry in
                        NavigationLink(destination: LockerSelectionView(park: entry.park, locker: entry.locker, saved: entry.saved)) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.locker.name)
                                    .font(.headline)
                                    .lineLimit(2)

                                savedLabel(entry.saved)
                            }
                            .padding(.vertical, 4)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                WKInterfaceDevice.current().play(.stop)
                                lockerStore.clear(park: entry.park, locker: entry.locker)
                            } label: {
                                Label("Clear", systemImage: "trash")
                            }
                        }
                    }
                }
            }

            ForEach(sortedParks, id: \.park.id) { group in
                Section {
                    ForEach(group.lockers) { locker in
                        NavigationLink(destination: LockerSelectionView(park: group.park, locker: locker, saved: lockerStore.saved(park: group.park, locker: locker))) {
                            lockerRow(park: group.park, locker: locker)
                        }
                    }
                } header: {
                    ParkSectionHeader(park: group.park, color: .orange)
                }
            }
        }
        .navigationTitle("Lockers")
        .onAppear {
            locationManager.start() // GPS ON when view appears
        }
        .onDisappear {
            locationManager.stop()  // GPS OFF when view vanishes
        }
    }

    private func lockerRow(park: Park, locker: Locker) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(locker.name)
                .font(.headline)
                .lineLimit(2)

            if let saved = lockerStore.saved(park: park, locker: locker) {
                savedLabel(saved)
            } else if let userLoc = locationManager.userLocation {
                Text(formatDistance(userLoc.distance(from: locker.location.clLocation)))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private func savedLabel(_ saved: SavedLocker) -> some View {
        Label("Section \(saved.section) · #\(saved.number)", systemImage: "checkmark.circle.fill")
            .font(.caption2)
            .foregroundColor(.green)
    }

    // Helper to make meters look like "0.2 mi" or "300 ft"
    private func formatDistance(_ meters: Double) -> String {
        let measurement = Measurement(value: meters, unit: UnitLength.meters)
        // Convert to user's preferred locale (miles or km)
        return measurement.formatted(.measurement(width: .abbreviated, usage: .road))
    }
}

#Preview {
    NavigationStack {
        LockerListView()
            .environmentObject(ParkInformationService())
            .environmentObject(SavedLockerStore())
    }
}
