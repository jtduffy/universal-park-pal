//
//  Park.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 8/7/25.
//

import Foundation

struct Park: Codable, Identifiable, Hashable {
    var id: String { name }
    let name: String
    let imageName: String
    let lockers: [Locker]
    var parkingLot: ParkingLocation?
    let paidLockers: [Locker]
    
    static func == (lhs: Park, rhs: Park) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case name, lockers, paidLockers, imageName, parkingLot
    }
}
