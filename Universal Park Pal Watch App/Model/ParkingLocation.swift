//
//  ParkingLot.swift
//  Universal Park Pal
//
//  Created by Jerry Duffy on 11/14/25.
//

import Foundation

struct ParkingLocation: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let location: Location
    let areas: [ParkingArea]
}
