//
//  QueueTimesDTO.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/29/25.
//

import Foundation

struct QueueTimesResponse: Decodable {
    let lands: [LandDTO]
}

struct LandDTO: Decodable {
    let id: Int
    let name: String
    let rides: [RideDTO]
}

struct RideDTO: Decodable, Identifiable {
    let id: Int
    let name: String
    let is_open: Bool
    let wait_time: Int
    let last_updated: String
}
