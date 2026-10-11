//
//  RideListView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/30/25.
//

import SwiftUI
import CoreLocation

struct RideListView: View {
    @EnvironmentObject var dataManager: ParkInformationService
    @StateObject private var locationManager = LocationManagerService()

    private enum LoadState {
        case loading
        case loaded([Ride])
        case failed
    }

    // Keyed by park id
    @State private var rideStates: [String: LoadState] = [:]

    // Closest park first, falls back to JSON order until we have a location fix
    var sortedParks: [Park] {
        guard let userLoc = locationManager.userLocation else {
            return dataManager.parks
        }

        return dataManager.parks.sorted { park1, park2 in
            userLoc.distance(from: park1.location.clLocation) < userLoc.distance(from: park2.location.clLocation)
        }
    }

    var body: some View {
        List {
            ForEach(sortedParks) { park in
                Section {
                    switch rideStates[park.id] ?? .loading {
                    case .loading:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .listRowBackground(Color.clear)
                    case .failed:
                        Text("Wait times unavailable")
                            .foregroundColor(.secondary)
                    case .loaded(let rides) where rides.isEmpty:
                        Text("No wait times available.")
                            .foregroundColor(.secondary)
                    case .loaded(let rides):
                        // Already sorted: open rides by shortest wait, then closed rides
                        ForEach(rides) { ride in
                            RideRowView(ride: ride)
                        }
                    }
                } header: {
                    ParkSectionHeader(park: park, color: .blue)
                }
            }

            // Attribution Footer
            Section {
                VStack(alignment: .leading) {
                    Text("Wait times provided by")
                        .font(.caption2)
                        .foregroundColor(.gray)

                    Link("Queue-Times.com", destination: URL(string: "https://queue-times.com/en-US")!)
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
                .listRowBackground(Color.clear) // Removes the grey box
            }
        }
        .navigationTitle("Wait Times")
        // Parks load asynchronously, so fetch again once they arrive
        .task(id: dataManager.parks.count) {
            await loadData()
        }
        .onAppear {
            locationManager.start()
        }
        .onDisappear {
            locationManager.stop()
        }
    }

    // Fetches every park at once so one slow park doesn't hold up the others
    private func loadData() async {
        await withTaskGroup(of: (String, LoadState).self) { group in
            for park in dataManager.parks {
                group.addTask {
                    do {
                        return (park.id, .loaded(try await RideWaitTimeService.fetchRides(for: park)))
                    } catch {
                        print("Error fetching rides for \(park.name): \(error)")
                        return (park.id, .failed)
                    }
                }
            }

            for await (parkId, state) in group {
                rideStates[parkId] = state
            }
        }
    }
}

#Preview {
    NavigationStack {
        RideListView()
            .environmentObject(ParkInformationService())
    }
}
