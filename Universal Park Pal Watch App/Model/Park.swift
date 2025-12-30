//
//  Park.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 8/7/25.
//

import Foundation

struct Park: Codable, Identifiable, Hashable {
    var id: String { name }
    let waitTimeId: Int?
    let name: String
    let imageName: String
    let lockers: [Locker]
    let paidLockers: [Locker]
    
    var parkingLot: ParkingLocation?
    var rides: [Ride] = []
    
    static func == (lhs: Park, rhs: Park) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case waitTimeId
        case name
        case imageName
        case lockers
        case paidLockers
        case parkingLot
    }
}
