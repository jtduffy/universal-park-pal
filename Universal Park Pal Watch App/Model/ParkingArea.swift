//
//  ParkingArea.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 8/17/25.
//

import Foundation

struct ParkingArea: Codable, Identifiable, Hashable {
    var id: String { section }
    let section: String
    let levels: [String]
    let rows: [String]
    
    static func == (lhs: ParkingArea, rhs: ParkingArea) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
