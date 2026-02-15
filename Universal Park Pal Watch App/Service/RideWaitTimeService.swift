//
//  RideWaitTimeDataService.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/29/25.
//

import Foundation

class RideWaitTimeService {
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    static func fetchRides(for park: Park) async throws -> [Ride] {
        let parkId: Int = park.waitTimeId!
        let allowedWaitTimeRideIds = park.allowedWaitTimeRideIds
        let urlString = "https://queue-times.com/parks/\(parkId)/queue_times.json"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Read the data into a QueueTimesDTO so we can convert them into proper "Ride" objects
        let decoder = JSONDecoder()
        let response = try decoder.decode(QueueTimesResponse.self, from: data)
        var ridesToAdd: [Ride] = []
        
        for land in response.lands {
            for rideDTO in land.rides {
                if (allowedWaitTimeRideIds.contains(rideDTO.id)) {
                    let dateObject = dateFormatter.date(from: rideDTO.last_updated)
                    
                    let newRide = Ride(
                        id: rideDTO.id,
                        name: rideDTO.name,
                        waitTime: rideDTO.wait_time,
                        isOpen: rideDTO.is_open,
                        lastUpdated: dateObject
                    )
                    
                    ridesToAdd.append(newRide)
                }
            }
        }
        
        // Sort by wait time, low -> high, then all closed rides alphabetically
        return ridesToAdd.sorted { (ride1, ride2) in
            // 1. Primary Sort: Status (Open first)
            if ride1.isOpen != ride2.isOpen {
                return ride1.isOpen
            }
            
            // 2. Secondary Sort: Wait Time (Low -> High)
            if ride1.waitTime != ride2.waitTime {
                return ride1.waitTime < ride2.waitTime
            }
            
            // 3. Tertiary Sort: Alphabetical (A -> Z)
            return ride1.name < ride2.name
        }
    }
}
