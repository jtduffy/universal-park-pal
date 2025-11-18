//
//  Ride.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 8/17/25.
//

import Foundation

struct LockerLocation: Codable, Identifiable {
    var id: String { name }
    let name: String
    let location: Location
    let sections: String
    let lockers: Int
}
