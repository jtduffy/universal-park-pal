//
//  Location.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 8/17/25.
//

import Foundation
import CoreLocation

struct Location: Codable, Hashable {
    let latitude: Double
    let longitude: Double
    
    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
