//
//  ParkingReminderView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 11/14/25.
//
import SwiftUI

struct ParkingReminderView: View {
    let parkingLot: ParkingLocation

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var parkingStore: SavedParkingStore

    // nil until the user picks a value, so the starting values never look saved
    @State private var selectedArea: ParkingArea?
    @State private var selectedLevel: ParkingLevel?
    @State private var selectedRow: String?

    private var savedSpot: SavedParkingSpot? {
        parkingStore.spot(in: parkingLot)
    }

    // saved: the stored spot for this lot, if any
    init(parkingLot: ParkingLocation, saved: SavedParkingSpot?) {
        self.parkingLot = parkingLot

        // Restore each saved value that's still valid, and fill in any field with only one choice
        let area = parkingLot.areas.first(where: { $0.section == saved?.section }) ?? Self.onlyOption(parkingLot.areas)

        let level = area.flatMap { area in
            area.levels.first(where: { $0.level == saved?.level }) ?? Self.onlyOption(area.levels)
        }

        let row = level.flatMap { level in
            level.rows.first(where: { $0 == saved?.row }) ?? Self.onlyOption(level.rows)
        }

        self._selectedArea = State(initialValue: area)
        self._selectedLevel = State(initialValue: level)
        self._selectedRow = State(initialValue: row)
    }

    var body: some View {
        Form {
            // Each field appears once the one before it is picked
            Section {
                SelectionRow(title: "Section", options: parkingLot.areas, selection: $selectedArea) { $0.section }

                if let selectedArea {
                    if selectedArea.levels.count > 1 {
                        SelectionRow(title: "Level", options: selectedArea.levels, selection: $selectedLevel) { $0.level }
                    } else if let selectedLevel {
                        levelDisplay(selectedLevel)
                    }
                }

                if let selectedLevel {
                    SelectionRow(title: "Row", options: selectedLevel.rows, selection: $selectedRow) { $0 }
                }
            }

            if savedSpot != nil {
                Section {
                    Button(role: .destructive, action: clearSelection) {
                        Label("Clear Parking", systemImage: "trash")
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.red)
                }
            }
        }
        // Each handler resets the fields that depend on it before saving, so a
        // new section is never saved with the previous section's row.
        .onChange(of: selectedArea) {
            selectedLevel = selectedArea.flatMap { Self.onlyOption($0.levels) }
            selectedRow = selectedLevel.flatMap { Self.onlyOption($0.rows) }
            saveIfComplete()
        }
        .onChange(of: selectedLevel) {
            selectedRow = selectedLevel.flatMap { Self.onlyOption($0.rows) }
            saveIfComplete()
        }
        .onChange(of: selectedRow) {
            saveIfComplete()
        }
        .navigationTitle("Parking")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Shown instead of a picker when the section only has one level
    private func levelDisplay(_ level: ParkingLevel) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Level")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.secondary)

            Text(level.level)
                .font(.title3)
                .fontWeight(.semibold)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 2)
        .listRowBackground(RoundedRectangle(cornerRadius: 9).fill(Color(white: 0.2)))
    }

    private static func onlyOption<T>(_ options: [T]) -> T? {
        options.count == 1 ? options.first : nil
    }

    // Saves only a full, valid spot. Nothing is saved just by opening and closing the screen.
    private func saveIfComplete() {
        guard let area = selectedArea,
              let level = selectedLevel, area.levels.contains(level),
              let row = selectedRow, level.rows.contains(row) else { return }

        let alreadySaved = savedSpot.map { $0.section == area.section && $0.level == level.level && $0.row == row } ?? false
        guard !alreadySaved else { return }

        WKInterfaceDevice.current().play(.notification)
        parkingStore.save(lot: parkingLot, section: area.section, level: level.level, row: row)
    }

    private func clearSelection() {
        WKInterfaceDevice.current().play(.stop)

        parkingStore.clear()

        // Return to the lot list so the pickers don't look like a saved spot
        dismiss()
    }
}

#Preview {
    NavigationStack {
        // This will show "Citywalk" data directly from your JSON file!
        ParkingReminderView(parkingLot: ParkingLocation.previewData[0], saved: nil)
            .environmentObject(SavedParkingStore())
    }
}
