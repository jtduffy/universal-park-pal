//
//  LockerSelectionView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/21/25.
//

import SwiftUI

struct LockerSelectionView: View {
    @Binding var isPresented: Bool
    let locker: Locker
    let mode: LockerType // Pass the mode to determine styling and storage
    
    @State private var selectedSection: String
    @State private var selectedNumber: Int
    
    // Check if data is saved for this specific mode/locker to show the clear button
    private var isDataSaved: Bool {
        UserDefaults.standard.string(forKey: mode.nameKey) == locker.name
    }
    
    init(isPresented: Binding<Bool>, locker: Locker, mode: LockerType) {
        self._isPresented = isPresented
        self.locker = locker
        self.mode = mode
        
        let availableSections = locker.sectionList
        
        // 1. Check for saved data using dynamic keys from the mode
        let savedName = UserDefaults.standard.string(forKey: mode.nameKey)
        let savedSection = UserDefaults.standard.string(forKey: mode.sectionKey)
        
        let initialSection: String
        if savedName == locker.name, let existing = savedSection {
            initialSection = existing
        } else {
            initialSection = availableSections.first ?? "1"
        }
        
        // 2. Determine initial number
        let savedNum = UserDefaults.standard.integer(forKey: mode.numberKey)
        let initialNumber = (savedName == locker.name && savedNum != 0) ? savedNum : 1
        
        self._selectedSection = State(initialValue: initialSection)
        self._selectedNumber = State(initialValue: initialNumber)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 10) {
                // --- SECTION COLUMN ---
                VStack(spacing: 2) {
                    Text("SECTION")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    Picker("Section", selection: $selectedSection) {
                        ForEach(locker.sectionList, id: \.self) { section in
                            Text(section).tag(section)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                }
                
                // --- NUMBER COLUMN ---
                VStack(spacing: 2) {
                    Text("NUMBER")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    Picker("Number", selection: $selectedNumber) {
                        ForEach(1...locker.lockers, id: \.self) { num in
                            Text("\(num)").tag(num)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                }
            }
            .frame(height: 90)
            .padding(.bottom, 5)
            
            Button(action: saveLockerSelection) {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(mode.themeColor) // Uses .blue for ride, .purple for paid
            
            if isDataSaved {
                Button(role: .destructive, action: clearLockerSelection) {
                    Label("Clear Locker", systemImage: "trash")
                        .font(.caption2)
                }
                .buttonStyle(.borderless)
                .foregroundColor(.red)
                .padding(.top, 2)
            }
        }
        .navigationTitle(locker.name)
    }
    
    private func saveLockerSelection() {
        WKInterfaceDevice.current().play(.notification)
        
        // Save using dynamic keys
        UserDefaults.standard.set(locker.name, forKey: mode.nameKey)
        UserDefaults.standard.set(selectedSection, forKey: mode.sectionKey)
        UserDefaults.standard.set(selectedNumber, forKey: mode.numberKey)
        
        isPresented = false
    }
    
    private func clearLockerSelection() {
        WKInterfaceDevice.current().play(.stop)
        
        // Clear using dynamic keys
        UserDefaults.standard.removeObject(forKey: mode.nameKey)
        UserDefaults.standard.removeObject(forKey: mode.sectionKey)
        UserDefaults.standard.set(0, forKey: mode.numberKey)
        
        isPresented = false
    }
}
