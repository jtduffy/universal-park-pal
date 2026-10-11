//
//  ContentView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 8/7/25.
//
import SwiftUI

struct MainView: View {
    @EnvironmentObject var lockerStore: SavedLockerStore
    @EnvironmentObject var parkingStore: SavedParkingStore

    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: RideListView()) {
                    menuLabel("Wait Times", systemImage: "clock.fill", color: .blue)
                }

                NavigationLink(destination: LockerListView()) {
                    menuLabel("Lockers", systemImage: "lock.square", color: .orange, detail: lockerDetail)
                }

                NavigationLink(destination: ParkingLotListView()) {
                    menuLabel("Car Locator", systemImage: "car.fill", color: .yellow,
                              detail: parkingStore.spot.map { "\($0.section) · L\($0.level) · Row \($0.row)" })
                }
            }
            .navigationTitle("Universal Park Pal")
        }
    }

    // One saved locker shows its spot, several show a count
    private var lockerDetail: String? {
        let saved = lockerStore.sortedLockers
        guard let first = saved.first else { return nil }
        
        if saved.count == 1 {
            return "Sec \(first.section) · #\(first.number) · \(first.lockerName)"
        }
        return "\(saved.count) lockers saved"
    }
    
    private func menuLabel(_ title: String, systemImage: String, color: Color, detail: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundColor(color)

            if let detail {
                Text(detail)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    MainView()
        .environmentObject(ParkInformationService())
        .environmentObject(SavedLockerStore())
        .environmentObject(SavedParkingStore())
}
