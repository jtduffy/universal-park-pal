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
    
    @AppStorage("savedParkingLotId") private var savedParkingLotId: String = ""
    @AppStorage("savedSection") private var savedSectionName: String = ""
    @AppStorage("savedLevel") private var savedLevelName: String = ""
    @AppStorage("savedRow") private var savedRow: String = ""
    
    // Initialize with placeholders to avoid complex init logic
    @State private var selectedArea: ParkingArea
    @State private var selectedLevel: ParkingLevel
    @State private var selectedRow: String
    
    init(parkingLot: ParkingLocation) {
        self.parkingLot = parkingLot
        
        // 1. Determine Area
        let sSection = UserDefaults.standard.string(forKey: "savedSection")
        let area = parkingLot.areas.first(where: { $0.section == sSection }) ?? parkingLot.areas.first!
        
        // 2. Determine Level
        let sLevel = UserDefaults.standard.string(forKey: "savedLevel")
        let level = area.levels.first(where: { $0.level == sLevel }) ?? area.levels.first!
        
        // 3. Determine Row (The fix is here)
        let savedRow = UserDefaults.standard.string(forKey: "savedRow")
        
        // Check if savedRow is nil OR empty. If either, use the first row of the current level.
        let row: String
        if let saved = savedRow, !saved.isEmpty {
            row = saved
        } else {
            row = level.rows.first ?? ""
        }
        
        // 4. Assign to State
        self._selectedArea = State(initialValue: area)
        self._selectedLevel = State(initialValue: level)
        self._selectedRow = State(initialValue: row)
    }
    
    var body: some View {
        Form {
            Section {
                // 1. Section Picker
                Picker("Section", selection: $selectedArea) {
                    ForEach(parkingLot.areas) { area in
                        Text(area.section).tag(area)
                    }
                }
                
                // 2. Level Picker
                if selectedArea.levels.count > 1 {
                    Picker("Level", selection: $selectedLevel) {
                        ForEach(selectedArea.levels) { levelObj in
                            Text(levelObj.level)
                                .minimumScaleFactor(0.8)
                                .lineLimit(1)
                                .tag(levelObj)
                        }
                    }
                } else {
                    levelDisplay
                }
                
                // 3. Row Picker
                Picker("Row", selection: $selectedRow) {
                    ForEach(selectedLevel.rows, id: \.self) { row in
                        Text(row).tag(row)
                    }
                }
            }
            
            // --- NEW CONFIRM SECTION ---
            Section {
                Button(action: saveParkingSelection) {
                    HStack {
                        Spacer()
                        Text("Confirm Spot")
                        Spacer()
                    }
                }
                .tint(.green)
                .buttonStyle(.borderedProminent)
            }
            .listRowBackground(Color.clear) // Makes the button stand out from the form
            
            if !savedSectionName.isEmpty {
                Section {
                    Button(role: .destructive, action: clearSelection) {
                        Label("Clear Parking", systemImage: "trash")
                    }
                    .buttonStyle(.borderless) // Standardized to borderless red
                    .foregroundColor(.red)
                }
            }
        }
        .onChange(of: selectedArea) {
            if let firstLevel = selectedArea.levels.first {
                selectedLevel = firstLevel
            }
        }
        .onChange(of: selectedLevel) {
            selectedRow = selectedLevel.rows.first ?? ""
        }
        .navigationTitle("Parking")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Extracted the static level display to keep body clean
    private var levelDisplay: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Level")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(selectedLevel.level)
                .font(.body)
                .fontWeight(.semibold)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 2)
        .listRowBackground(RoundedRectangle(cornerRadius: 9).fill(Color(white: 0.2)))
    }
    
    // --- NEW SAVE LOGIC WITH HAPTICS ---
    private func saveParkingSelection() {
        // Play success haptic
        WKInterfaceDevice.current().play(.notification)
        
        // Commit values to AppStorage
        savedParkingLotId = parkingLot.id
        savedSectionName = selectedArea.section
        savedLevelName = selectedLevel.level
        savedRow = selectedRow
        
        dismiss()
    }
    
    private func clearSelection() {
        // Standardizing the haptic to match the locker reset
        WKInterfaceDevice.current().play(.stop)
        
        // Clear the AppStorage
        savedParkingLotId = ""
        savedSectionName = ""
        savedLevelName = ""
        savedRow = ""
        
        // Standardizing the behavior: return to main menu after clearing
        dismiss()
    }
}

#Preview {
    NavigationStack {
        // This will show "Citywalk" data directly from your JSON file!
        ParkingReminderView(parkingLot: ParkingLocation.previewData[0])
    }
}
