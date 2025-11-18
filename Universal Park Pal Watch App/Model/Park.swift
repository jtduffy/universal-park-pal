//
//  Park.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 8/7/25.
//

import Foundation

struct Park: Codable, Identifiable {
    var id: String { name }
    let name: String
    let imageName: String
    let lockers: [LockerLocation]
    var parkingLot: ParkingLot?
    //let otherLockers: [PaidLocker]
    
    enum CodingKeys: String, CodingKey {
        case name, lockers, imageName
    }
}
