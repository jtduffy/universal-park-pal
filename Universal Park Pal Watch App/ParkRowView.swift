//
//  ParkRowView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/22/25.
//

import SwiftUI

struct ParkRowView: View {
    let park: Park
    @Binding var selectedParkForLockers: Park?
    @Binding var selectedParkForPaidLockers: Park?
    
    // 1. Persistent Storage
    @AppStorage("savedParkingLotId") private var savedParkingLotId: String = ""
    @AppStorage("savedSection") private var savedParkingSection: String = ""
    @AppStorage("savedLevel") private var savedLevel: String = "" // Added this
    @AppStorage("savedRow") private var savedRow: String = ""
    
    @AppStorage("savedLockerName") private var savedLockerName: String = ""
    @AppStorage("savedLockerSection") private var savedLockerSection: String = ""
    @AppStorage("savedLockerNumber") private var savedLockerNumber: Int = 0
    
    @AppStorage("savedPaidLockerName") private var savedPaidLockerName: String = ""
    @AppStorage("savedPaidLockerSection") private var savedPaidLockerSection: String = ""
    @AppStorage("savedPaidLockerNumber") private var savedPaidLockerNumber: Int = 0
    
    
    var body: some View {
        Section(header: headerView) {
            Button(action: {
                selectedParkForLockers = park
            }) {
                rideLockerLabel
            }
            
            Button(action: {
                selectedParkForPaidLockers = park
            }) {
                paidLockerLabel
            }
            
            if let parkingLot = park.parkingLot {
                NavigationLink(destination: ParkingReminderView(parkingLot: parkingLot)) {
                    parkingLabel
                }
            }
        }
    }
    
    // --- Sub-Components ---
    
    private var headerView: some View {
        HStack(spacing: 5) {
            Image(systemName: park.imageName)
            Text(park.name)
        }
        .font(.title3)
        .fontDesign(.rounded)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .padding(.bottom, 3)
    }
    
    private var rideLockerLabel: some View {
        VStack(alignment: .leading, spacing: 2) {
            Label("Ride Lockers", systemImage: "lock.square")
                .font(.caption.weight(.medium))
                .textCase(.uppercase)
                .kerning(1.0)
                .foregroundColor(.blue)
            
            if !savedLockerName.isEmpty && park.lockers.contains(where: { $0.name == savedLockerName }) {
                Group {
                    Text(savedLockerName)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text("Section: \(savedLockerSection) - Number: \(savedLockerNumber)")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 2)
    }
    
    private var paidLockerLabel: some View {
        VStack(alignment: .leading, spacing: 2) {
            Label("Paid Lockers", systemImage: "dollarsign.square")
                .font(.caption.weight(.medium))
                .textCase(.uppercase)
                .kerning(1.0)
                .foregroundColor(.purple)
            
            if !savedPaidLockerName.isEmpty && park.paidLockers.contains(where: { $0.name == savedPaidLockerName }) {
                Group {
                    Text(savedPaidLockerName)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text("Section: \(savedPaidLockerSection) - Number\(savedPaidLockerNumber)")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 2)
    }
    
    private var parkingLabel: some View {
        VStack(alignment: .leading, spacing: 2) {
            Label("Parking", systemImage: "car")
                .font(.caption.weight(.medium))
                .textCase(.uppercase)
                .kerning(1.0)
                .foregroundColor(.green)
            
            // THE FIX: Check if the saved lot matches this specific park's lot
            if let lot = park.parkingLot, lot.id == savedParkingLotId, !savedParkingSection.isEmpty {
                Group {
                    Text("\(savedParkingSection) - Level: \(savedLevel)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text("Row \(savedRow)")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 2)
    }
}
