//
//  RideWaitTimeDataService.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/29/25.
//

import Foundation

class RideWaitTimeDataService {
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    // We make this static so you can call it from anywhere without creating an instance
    static func fetchRides(for parkId: Int) async throws -> [Ride] {
        
        // 1. Construct the URL
        let urlString = "https://queue-times.com/parks/\(parkId)/queue_times.json"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // 2. Fetch Data
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // 3. Decode the "Messy" DTO
        let decoder = JSONDecoder()
        let response = try decoder.decode(QueueTimesResponse.self, from: data)
        
        // 4. The "Manual Mapping" (Flatten Lands -> Rides)
        var cleanedRides: [Ride] = []
        
        for land in response.lands {
            for rideDTO in land.rides {
                let dateObject = dateFormatter.date(from: rideDTO.last_updated)
                
                let newRide = Ride(
                    id: rideDTO.id,
                    name: rideDTO.name,
                    waitTime: rideDTO.wait_time,
                    isOpen: rideDTO.is_open,
                    lastUpdated: dateObject
                )
                
                cleanedRides.append(newRide)
            }
        }
        
        // 5. Sort them (Optional: Currently sorting by wait time,  low to high)
        return cleanedRides.sorted { $0.waitTime < $1.waitTime }
    }
}
