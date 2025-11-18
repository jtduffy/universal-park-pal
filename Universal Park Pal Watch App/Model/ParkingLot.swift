//
//  ParkingLot.swift
//  Universal Park Pal
//
//  Created by Jerry Duffy on 11/14/25.
//

import Foundation

struct ParkingLot: Codable, Identifiable {
    let id: String
    let areas: [ParkingArea]
}
