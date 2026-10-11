//
//  LockerSelectionView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/21/25.
//

import SwiftUI

struct LockerSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var lockerStore: SavedLockerStore

    let park: Park
    let locker: Locker

    // nil until the user picks a value, so the starting values never look saved
    @State private var selectedSection: String?
    @State private var selectedNumber: Int?

    private var isSaved: Bool {
        lockerStore.saved(park: park, locker: locker) != nil
    }

    init(park: Park, locker: Locker, saved: SavedLocker?) {
        self.park = park
        self.locker = locker

        // Restore the saved values if they're still valid. A locker with a single
        // section has nothing to choose, so fill it in.
        let sections = locker.sectionList
        let section = sections.first(where: { $0 == saved?.section }) ?? (sections.count == 1 ? sections.first : nil)
        let number = saved.map(\.number).flatMap { (1...locker.lockers).contains($0) ? $0 : nil }

        self._selectedSection = State(initialValue: section)
        self._selectedNumber = State(initialValue: number)
    }

    var body: some View {
        Form {
            Section {
                SelectionRow(title: "Section", options: locker.sectionList, selection: $selectedSection, gridColumns: 5) { $0 }

                SelectionRow(title: "Number", options: Array(1...locker.lockers), selection: $selectedNumber, gridColumns: 5) { "\($0)" }
            }

            if isSaved {
                Section {
                    Button(role: .destructive, action: clearLockerSelection) {
                        Label("Clear Locker", systemImage: "trash")
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.red)
                }
            }
        }
        // Saves once both values are picked. Nothing is saved
        // just by opening and closing the screen.
        .onChange(of: selectedSection) { saveLockerSelection() }
        .onChange(of: selectedNumber) { saveLockerSelection() }
        .navigationTitle(locker.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveLockerSelection() {
        guard let selectedSection, let selectedNumber else { return }

        WKInterfaceDevice.current().play(.notification)
        lockerStore.save(park: park, locker: locker, section: selectedSection, number: selectedNumber)
    }

    private func clearLockerSelection() {
        WKInterfaceDevice.current().play(.stop)

        lockerStore.clear(park: park, locker: locker)

        // Return to the locker list so the pickers don't look like a saved locker
        dismiss()
    }
}
