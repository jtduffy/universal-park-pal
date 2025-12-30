//
//  Ride.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/29/25.
//

import Foundation

import Foundation

struct Ride: Identifiable, Hashable {
    let id: Int
    let name: String
    let waitTime: Int
    let isOpen: Bool
    let lastUpdated: Date?
    
    // Helper to format the wait time string for the UI
    var waitTimeText: String {
        if !isOpen { return "Closed" }
        return "\(waitTime) mins"
    }
}

extension Ride {
    static let mockData: [Ride] = [
        Ride(id: 1, name: "Hagrid's Magical Creatures Motorbike Adventure", waitTime: 120, isOpen: true, lastUpdated: Date()),
        Ride(id: 2, name: "VelociCoaster", waitTime: 45, isOpen: true, lastUpdated: Date()),
        Ride(id: 3, name: "Flight of the Hippogriff", waitTime: 10, isOpen: true, lastUpdated: Date()),
        Ride(id: 4, name: "Pteranodon Flyers", waitTime: 0, isOpen: false, lastUpdated: Date()) // Closed example
    ]
}
