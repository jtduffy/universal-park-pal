//
//  SavedParkingSpot.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 10/11/26.
//

import Foundation

struct SavedParkingSpot: Codable, Hashable {
    let lotId: String
    let section: String
    let level: String
    let row: String
    let savedAt: Date
}
