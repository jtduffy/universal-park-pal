//
//  ParkingLevel.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/21/25.
//

import Foundation

struct ParkingLevel: Codable, Identifiable, Hashable {
    var id: String { level }
    let level: String
    let rows: [String]
}
