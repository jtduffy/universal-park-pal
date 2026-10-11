//
//  SavedLocker.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 10/11/26.
//

import Foundation

struct SavedLocker: Codable, Identifiable, Hashable {
    // Locker names aren't unique across parks (e.g. Forbidden Journey), so key on both
    var id: String { SavedLocker.id(parkName: parkName, lockerName: lockerName) }
    let parkName: String
    let lockerName: String
    let section: String
    let number: Int
    let savedAt: Date

    static func id(parkName: String, lockerName: String) -> String {
        "\(parkName)/\(lockerName)"
    }
}
