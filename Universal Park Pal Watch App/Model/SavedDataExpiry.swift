//
//  SavedDataExpiry.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 10/11/26.
//

import Foundation

// Saved parking spots and lockers only matter for a single park day,
// so anything older than this is cleared automatically by
// SavedParkingStore.purgeExpired() and SavedLockerStore.purgeExpired().
enum SavedDataExpiry {
    static let maxAge: TimeInterval = 18 * 60 * 60
}
