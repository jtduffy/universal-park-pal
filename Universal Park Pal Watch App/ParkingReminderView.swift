//
//  ParkingReminderView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 11/14/25.
//

import SwiftUI

struct ParkingReminderView: View {
    let parkingLot: ParkingLot
    @State private var selectedArea: ParkingArea
    @State private var selectedLevel: String
    @State private var selectedRow: String
    
    init(parkingLot: ParkingLot) {
        self.parkingLot = parkingLot
        
        let firstArea = parkingLot.areas.first!
        _selectedArea = State(initialValue: firstArea)
        _selectedLevel = State(initialValue: firstArea.levels.first ?? "")
        _selectedRow = State(initialValue: firstArea.rows.first ?? "")
    }
    
    var body: some View {
        Form {
            Picker("Section", selection: $selectedArea) {
                ForEach(parkingLot.areas) { area in
                    Text(area.section).tag(area)
                }
            }
            
            Picker("Level", selection: $selectedLevel) {
                ForEach(selectedArea.levels, id: \.self) { level in
                    Text(level).tag(level)
                }
            }
            
            Picker("Row", selection: $selectedRow) {
                ForEach(selectedArea.rows, id: \.self) { row in
                    Text(row).tag(row)
                }
            }
        }
        .onChange(of: selectedArea) {
            // Inside this closure, 'selectedArea' has already
            // been updated to its new value, so we can
            // read it directly to update the other pickers.
            selectedLevel = selectedArea.levels.first ?? ""
            selectedRow = selectedArea.rows.first ?? ""
        }
        .navigationTitle("Parking Reminder")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // We wrap the view in a NavigationStack
    // to see the title and layout correctly.
    NavigationStack {
        ParkingReminderView(parkingLot: .mock)
    }
}

extension ParkingLot {
    static var mock: ParkingLot {
        
        // 1. Create mock areas
        let area1 = ParkingArea(
            section: "Jaws",
            levels: ["1", "2", "3"],
            rows: ["101", "102", "103", "104"]
        )
        
        let area2 = ParkingArea(
            section: "King Kong",
            levels: ["4", "5"],
            rows: ["405", "406", "407", "408", "409", "410", "411"]
        )
        
        let area3 = ParkingArea(
            section: "Spider-Man",
            levels: ["6", "7", "8"],
            rows: ["601", "602"]
        )
        
        return ParkingLot(
            id: "citywalk",
            areas: [area1, area2, area3]
        )
    }
}
