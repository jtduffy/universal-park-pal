//
//  LockerSelectionView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/21/25.
//

import SwiftUI

struct LockerSelectionView: View {
    // 1. DELETE: We no longer accept a binding from the parent
    // @Binding var isPresented: Bool
    
    // 2. ADD: We use the Environment to dismiss ourselves
    @Environment(\.dismiss) private var dismiss
    
    let locker: Locker
    let mode: LockerType
    
    @State private var selectedSection: String
    @State private var selectedNumber: Int
    
    private var isDataSaved: Bool {
        UserDefaults.standard.string(forKey: mode.nameKey) == locker.name
    }
    
    // 3. UPDATE INIT: Remove 'isPresented' from arguments
    init(locker: Locker, mode: LockerType) {
        // self._isPresented = isPresented // DELETE THIS
        self.locker = locker
        self.mode = mode
        
        let availableSections = locker.sectionList
        
        // Check for saved data using dynamic keys from the mode
        let savedName = UserDefaults.standard.string(forKey: mode.nameKey)
        let savedSection = UserDefaults.standard.string(forKey: mode.sectionKey)
        
        let initialSection: String
        if savedName == locker.name, let existing = savedSection {
            initialSection = existing
        } else {
            initialSection = availableSections.first ?? "1"
        }
        
        // Determine initial number
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
            .tint(mode.themeColor)
            
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
        
        // 4. THE FIX: Pop the view off the stack
        dismiss()
    }
    
    private func clearLockerSelection() {
        WKInterfaceDevice.current().play(.stop)
        
        // Clear using dynamic keys
        UserDefaults.standard.removeObject(forKey: mode.nameKey)
        UserDefaults.standard.removeObject(forKey: mode.sectionKey)
        UserDefaults.standard.set(0, forKey: mode.numberKey)
        
        // 4. THE FIX: Pop the view off the stack
        dismiss()
    }
}
