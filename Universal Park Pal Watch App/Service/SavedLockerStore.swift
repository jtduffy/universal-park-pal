//
//  SavedLockerStore.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 10/11/26.
//

import Foundation

// Holds every saved locker, at most one per locker location
class SavedLockerStore: ObservableObject {
    @Published private(set) var lockers: [SavedLocker] = []

    private let storageKey = "savedLockers"

    // Single-locker keys from before multiple lockers were supported
    private let legacyKeys = [
        "savedLockerName", "savedLockerSection", "savedLockerNumber", "savedLockerDate",
        "savedPaidLockerName", "savedPaidLockerSection", "savedPaidLockerNumber", "savedPaidLockerDate"
    ]

    init() {
        legacyKeys.forEach { UserDefaults.standard.removeObject(forKey: $0) }

        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([SavedLocker].self, from: data) {
            lockers = decoded
        }
    }

    // Most recently saved first
    var sortedLockers: [SavedLocker] {
        lockers.sorted { $0.savedAt > $1.savedAt }
    }

    func saved(park: Park, locker: Locker) -> SavedLocker? {
        let id = SavedLocker.id(parkName: park.name, lockerName: locker.name)
        return lockers.first { $0.id == id }
    }

    func save(park: Park, locker: Locker, section: String, number: Int) {
        let entry = SavedLocker(
            parkName: park.name,
            lockerName: locker.name,
            section: section,
            number: number,
            savedAt: Date()
        )
        lockers.removeAll { $0.id == entry.id }
        lockers.append(entry)
        persist()
    }

    func clear(park: Park, locker: Locker) {
        let id = SavedLocker.id(parkName: park.name, lockerName: locker.name)
        lockers.removeAll { $0.id == id }
        persist()
    }

    func purgeExpired() {
        let countBefore = lockers.count
        lockers.removeAll { Date().timeIntervalSince($0.savedAt) > SavedDataExpiry.maxAge }

        if lockers.count != countBefore {
            persist()
        }
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(lockers) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
