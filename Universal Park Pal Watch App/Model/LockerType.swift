//
//  LockerType.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/24/25.
//

import Foundation
import SwiftUI

enum LockerType {
    case ride
    case paid

    var title: String {
        self == .ride ? "Ride Lockers" : "Paid Lockers"
    }

    var themeColor: Color {
        self == .ride ? .blue : .purple
    }

    // These keys must match your @AppStorage strings
    var nameKey: String { self == .ride ? "savedLockerName" : "savedPaidLockerName" }
    var sectionKey: String { self == .ride ? "savedLockerSection" : "savedPaidLockerSection" }
    var numberKey: String { self == .ride ? "savedLockerNumber" : "savedPaidLockerNumber" }
}
