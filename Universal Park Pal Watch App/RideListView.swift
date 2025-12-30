//
//  RideListView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/30/25.
//

import SwiftUI

struct RideListView: View {
    let park: Park
    @State private var rides: [Ride] = []
    @State private var isLoading = true
    
    var body: some View {
        List {
            if isLoading {
                ProgressView("Loading Wait Times...")
            } else if rides.isEmpty {
                Text("No wait times available.")
            } else {
                // The Ride List
                ForEach(rides) { ride in
                    RideRowView(ride: ride)
                }
                
                // REQUIRED ATTRIBUTION FOOTER
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
        }
        .navigationTitle(park.name)
        .task {
            await loadData()
        }
    }
    
    // Logic to load data (Swappable between Mock and Real)
    private func loadData() async {
        // TEMPORARY: Simulate network delay then load Mock Data
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000) // 1 second delay
        
        self.rides = Ride.mockData
        self.isLoading = false
        
        /* // TODO: Uncomment this when on personal machine/VPN is fixed
         if let parkId = park.waitTimeId {
             do {
                 let fetchedRides = try await RideWaitTimeDataService.fetchRides(for: parkId)
                 self.rides = fetchedRides
                 self.isLoading = false
             } catch {
                 print("Error fetching rides: \(error)")
                 self.isLoading = false
             }
         }
         */
    }
}
