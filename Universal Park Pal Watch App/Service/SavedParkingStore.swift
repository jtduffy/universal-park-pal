//
//  SavedParkingStore.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 10/11/26.
//

import Foundation

// Holds the one saved parking spot
class SavedParkingStore: ObservableObject {
    @Published private(set) var spot: SavedParkingSpot?

    private let storageKey = "savedParkingSpot"

    // Separate keys from before the spot was stored as one value
    private let legacyKeys = ["savedParkingLotId", "savedSection", "savedLevel", "savedRow", "savedParkingDate"]

    init() {
        legacyKeys.forEach { UserDefaults.standard.removeObject(forKey: $0) }

        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(SavedParkingSpot.self, from: data) {
            spot = decoded
        }
    }

    // The saved spot, only if it belongs to this lot
    func spot(in lot: ParkingLocation) -> SavedParkingSpot? {
        spot?.lotId == lot.id ? spot : nil
    }

    func save(lot: ParkingLocation, section: String, level: String, row: String) {
        spot = SavedParkingSpot(lotId: lot.id, section: section, level: level, row: row, savedAt: Date())
        persist()
    }

    func clear() {
        spot = nil
        persist()
    }

    func purgeExpired() {
        if let spot, Date().timeIntervalSince(spot.savedAt) > SavedDataExpiry.maxAge {
            clear()
        }
    }

    private func persist() {
        if let spot, let data = try? JSONEncoder().encode(spot) {
            UserDefaults.standard.set(data, forKey: storageKey)
        } else {
            UserDefaults.standard.removeObject(forKey: storageKey)
        }
    }
}
